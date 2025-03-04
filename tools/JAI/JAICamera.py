import datetime
import os
import time

import eBUS as eb
import PvSampleUtils as psu
import cv2

BUFFER_COUNT =  16

def search_ip(input_string):
    import re
    # 正则表达式模式，用于匹配IP地址（这里假设IP地址总是在方括号内）
    pattern = r'\[(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]'
    # 搜索匹配项
    match = re.search(pattern, str(input_string))
    if match:
        ip_address = match.group(1)
        return ip_address

def connect_to_device(connection_ID):
    # Connect to the GigE Vision or USB3 Vision device
    print("Connecting to device.")
    result, device = eb.PvDevice.CreateAndConnect(connection_ID)
    if device == None:
        print(f"Unable to connect to device: {result.GetCodeString()} ({result.GetDescription()})")
    return device

def open_stream(connection_ID):
    # Open stream to the GigE Vision or USB3 Vision device
    print("Opening stream from device.")
    result, stream = eb.PvStream.CreateAndOpen(connection_ID)
    if stream == None:
        print(f"Unable to stream from device. {result.GetCodeString()} ({result.GetDescription()})")
    return stream

def configure_stream(device, stream):
    # If this is a GigE Vision device, configure GigE Vision specific streaming parameters
    if isinstance(device, eb.PvDeviceGEV):
        # Negotiate packet size
        device.NegotiatePacketSize()
        # Configure device streaming destination
        device.SetStreamDestination(stream.GetLocalIPAddress(), stream.GetLocalPort())

def configure_stream_buffers(device, stream):
    buffer_list = []
    # Reading payload size from device
    size = device.GetPayloadSize()

    # Use BUFFER_COUNT or the maximum number of buffers, whichever is smaller
    buffer_count = stream.GetQueuedBufferMaximum()
    if buffer_count > BUFFER_COUNT:
        buffer_count = BUFFER_COUNT

    # Allocate buffers
    for i in range(buffer_count):
        # Create new pvbuffer object
        pvbuffer = eb.PvBuffer()
        # Have the new pvbuffer object allocate payload memory
        pvbuffer.Alloc(size)
        # Add to external list - used to eventually release the buffers
        buffer_list.append(pvbuffer)

    # Queue all buffers in the stream
    for pvbuffer in buffer_list:
        stream.QueueBuffer(pvbuffer)
    print(f"Created {buffer_count} buffers")
    return buffer_list

def process_pv_buffer(pvbuffer):
    #图像处理
    """
    Use this method to process the buffer with your own algorithm.

    """
    print_string_value = "Image Processing"

    image = pvbuffer.GetImage()
    pixel_type = image.GetPixelType()

    # Verify we can handle this format, otherwise continue.
    if (pixel_type != eb.PvPixelMono8) and (pixel_type != eb.PvPixelRGB8):
        return pvbuffer

    # Retrieve Numpy arrayq
    image_data = image.GetDataPointer()

    # Here is an example of using opencv to place some text and a circle
    # in the image.
    cv2.putText(image_data, print_string_value,
                (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, 0, 4)

    # Place the circle in the middle of the image
    circle_centre_width_pos = image.GetWidth() // 2
    circle_centre_height_pos = image.GetHeight() // 2
    cv2.circle(image_data, ( circle_centre_width_pos, circle_centre_height_pos ),
            50, 0, 4 )
    return

def acquire_images(device, stream,kb):
    opencv_is_available = True
    # Get device parameters need to control streaming
    device_params = device.GetParameters()

    # Map the GenICam AcquisitionStart and AcquisitionStop commands
    start = device_params.Get("AcquisitionStart")
    stop = device_params.Get("AcquisitionStop")

    # Get stream parameters
    stream_params = stream.GetParameters()

    # Map a few GenICam stream stats counters
    frame_rate = stream_params.Get("AcquisitionRate")
    bandwidth = stream_params["Bandwidth"]

    # Enable streaming and send the AcquisitionStart command
    print("Enabling streaming and sending AcquisitionStart command.")
    device.StreamEnable()
    start.Execute()

    doodle = "|\\-|-/"
    doodle_index = 0
    display_image = False
    warning_issued = False

    # Acquire images until the user instructs us to stop.
    print("\n<press a key to stop streaming>")
    kb.start()
    while not kb.is_stopping():
        # Retrieve next pvbuffer
        result, pvbuffer, operational_result = stream.RetrieveBuffer(1000)
        if result.IsOK():
            if operational_result.IsOK():
                #
                # We now have a valid pvbuffer.
                # This is where you would typically process the pvbuffer.
                if opencv_is_available:
                    process_pv_buffer(pvbuffer)
                # ...

                result, frame_rate_val = frame_rate.GetValue()
                result, bandwidth_val = bandwidth.GetValue()

                print(f"{doodle[doodle_index]} BlockID: {pvbuffer.GetBlockID():016d}", end='')

                payload_type = pvbuffer.GetPayloadType()
                if payload_type == eb.PvPayloadTypeImage:
                    image = pvbuffer.GetImage()
                    image_data = image.GetDataPointer()
                    print(f" W: {image.GetWidth()} H: {image.GetHeight()} ", end='')

                    if opencv_is_available:
                        if image.GetPixelType() == eb.PvPixelMono8:
                            display_image = True
                        if image.GetPixelType() == eb.PvPixelRGB8:
                            image_data = cv2.cvtColor(image_data, cv2.COLOR_RGB2BGR)
                            display_image = True

                        if display_image:
                            cv2.imshow("stream", image_data)
                        else:
                            if not warning_issued:
                                # display a message that video only display for Mono0 / RGB8 images
                                print(f" ")
                                print(f" Currently only Mono8 / RGB8 images are displayed", end='\r')
                                print(f"")
                                warning_issued = True

                        if cv2.waitKey(1) & 0xFF != 0xFF:
                            break

                elif payload_type == eb.PvPayloadTypeChunkData:
                    print(f" Chunk Data payload type with {pvbuffer.GetChunkCount()} chunks", end='')

                elif payload_type == eb.PvPayloadTypeRawData:
                    print(f" Raw Data with {pvbuffer.GetRawData().GetPayloadLength()} bytes", end='')

                elif payload_type == eb.PvPayloadTypeMultiPart:
                    print(f" Multi Part with {pvbuffer.GetMultiPartContainer().GetPartCount()} parts", end='')

                else:
                    print(" Payload type not supported by this sample", end='')

                print(f" {frame_rate_val:.1f} FPS  {bandwidth_val / 1000000.0:.1f} Mb/s     ", end='\r')
            else:
                # Non OK operational result
                print(f"{doodle[doodle_index]} {operational_result.GetCodeString()}       ", end='\r')
            # Re-queue the pvbuffer in the stream object
            stream.QueueBuffer(pvbuffer)

        else:
            # Retrieve pvbuffer failure
            print(f"{doodle[doodle_index]} {result.GetCodeString()}      ", end='\r')

        doodle_index = (doodle_index + 1) % 6
        if kb.kbhit():
            kb.getch()
            break

    kb.stop()
    if opencv_is_available:
        cv2.destroyAllWindows()

    # Tell the device to stop sending images.
    print("\nSending AcquisitionStop command to the device")
    stop.Execute()

    # Disable streaming on the device
    print("Disable streaming on the controller.")
    device.StreamDisable()

    # Abort all buffers from the stream and dequeue
    print("Aborting buffers still in stream")
    stream.AbortQueuedBuffers()
    while stream.GetQueuedBufferCount() > 0:
        result, pvbuffer, lOperationalResult = stream.RetrieveBuffer()




class JAICamera():
    def __init__(self):
        self.retry = False

        self.fps = 31
        self.width = 1392
        self.height = 1040
        self.output_folder = "output"
        self.outwriter = None

        self.kb = psu.PvKb()
        self.kb.start()
        self.connection_ID = self.search_carame()
        self.device = connect_to_device(self.connection_ID)
        self.stream = open_stream(self.connection_ID)
        configure_stream(self.device, self.stream)
        self.buffer_list = configure_stream_buffers(self.device, self.stream)

        # 开始读取视频 案例
        # acquire_images(self.device, self.stream,self.kb)
        device_params = self.device.GetParameters()
        self.start = device_params.Get("AcquisitionStart")
        self.stop = device_params.Get("AcquisitionStop")
        self.device.StreamEnable()
        self.start.Execute()
        self.kb.start()

    def is_running(self):
        if self.kb.kbhit():
            self.kb.getch()
            return False
        return not self.kb.is_stopping() and not self.retry

    def read(self):
        ret = False
        frame = None
        result, pvbuffer, operational_result = self.stream.RetrieveBuffer(1000)
        if result.IsOK():
            if operational_result.IsOK():
                image = pvbuffer.GetImage()
                frame = image.GetDataPointer()
                ret = True
            self.stream.QueueBuffer(pvbuffer)
        else:
            print('相机断开了..')
            self.retry  = True
        return ret,frame

    def release(self):
        try:
            if self.outwriter:
                self.outwriter.release()
            self.kb.stop()
            cv2.destroyAllWindows()
            self.stop.Execute()
            self.device.StreamDisable()
            self.stream.AbortQueuedBuffers()
        except Exception as e:
            pass


    def __del__(self):
        self.release()
        self.close()

    def close(self):
        print('关闭相机')
        try:
            self.buffer_list.clear()
            self.stream.Close()
            eb.PvStream.Free(self.stream)
            self.device.Disconnect()
            eb.PvDevice.Free(self.device)

            self.kb.start()
            self.kb.getch()
            self.kb.stop()
        except Exception as e:
            pass

    def search_carame(self):
        lSystem = eb.PvSystem()
        while not self.kb.is_stopping():
            lSystem.Find()
            for i in range(lSystem.GetInterfaceCount()):
                lInterface = lSystem.GetInterface(i)
                for j in range(lInterface.GetDeviceCount()):
                    lDI = lInterface.GetDeviceInfo(j)
                    carmera = search_ip(lDI.GetDisplayID())
                    if carmera:
                        print("查找到设备_ip:",carmera)
                        return carmera
            time.sleep(3)
            print('未找到设备...')

    def create_writer(self):
        # 录视频
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = os.path.join(self.output_folder, f'{timestamp}.mp4')
        fourcc = cv2.VideoWriter_fourcc(*'H264')  # 设置视频编码格式为H264
        self.outwriter = cv2.VideoWriter(output_file, fourcc, self.fps, (self.width, self.height))
if __name__ == '__main__':
    cap = JAICamera()
    # 截图和录像的标记
    is_recording = False
    while cap.is_running():
        ret,frame = cap.read()
        if ret:
            #显示时间
            print_string_value = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            cv2.putText(frame, print_string_value,
                        (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, 0, 4)


            cv2.imshow('test',frame)
        else:
            time.sleep(0.05)
        if is_recording:
            cap.outwriter.write(frame)

        key = cv2.waitKey(1) & 0xFF
        if key == ord('q'):
            break
        elif key == ord('s'):  # 按's'键截图
            screenshot_path = os.path.join(cap.output_folder, 'screenshot_{}.png'.format(datetime.datetime.now().strftime('%Y%m%d_%H%M%S')))
            cv2.imwrite(screenshot_path, frame)
            print(f"Screenshot saved at {screenshot_path}")

        elif key == ord('r'):  # 按'r'键开始/停止录像
            is_recording = not is_recording
            if is_recording:
                print("Started recording.")
                cap.create_writer()
            else:
                print("Stopped recording.",)
                cap.outwriter.release()
    cap.release()
    cap.close()

