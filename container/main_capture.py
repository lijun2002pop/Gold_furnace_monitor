import datetime
import os
import threading
import time

import cv2

from tools.backend_thread import BackendThread


class MainCapture(BackendThread):
    def __init__(self, _backend,):
        super().__init__(_backend)
        self.backend = _backend
        self.camera = self.backend.camera

        #录像用
        self.fps = 10
        self.width = 1392
        self.height = 1040
        self.outwriter = None
        self.is_recording = False


    def create_writer(self):
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = os.path.join(self.backend.save_path, f'{timestamp}.avi')
        print(output_file)
        fourcc = cv2.VideoWriter_fourcc(*'XVID')  # 使用 XVID 编码器（适用于 AVI 格式）
        self.outwriter = cv2.VideoWriter(output_file, fourcc, self.fps, (self.width, self.height))

    def handle(self):
        url = r"C:\Users\lijun\Desktop\project\bayuquan2023\CLIENT01\download\D01_20220714.mp4"
        cap = cv2.VideoCapture(url)
        self.fps = cap.get(cv2.CAP_PROP_FPS)  # 帧率
        self.width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 帧宽度
        self.height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 帧高度
        ret, frame = cap.read()
        while ret and not self.backend.stopped:
            # 显示时间
            print_string_value = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            cv2.putText(frame, print_string_value,
                        (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, 0, 4)
            #存录像
            if self.is_recording and self.outwriter is not None:
                self.outwriter.write(frame)
            if self.camera.take_video_start:
                self.camera.take_video_start = False
                self.is_recording = not self.is_recording
                if self.is_recording:
                    print("Started recording.")
                    threading.Thread(target=self.create_writer).start()
                else:
                    print("Stopped recording.", )
                    self.outwriter.release()

            frame = cv2.resize(frame, (960, 640))
            self.backend.camera.image = frame
            ret, frame = cap.read()
            time.sleep(0.05)

        if self.outwriter:
            self.outwriter.release()
        cap.release()
        time.sleep(0.1)
        return True

