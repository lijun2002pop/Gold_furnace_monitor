import cv2

# 视频文件路径
url = r"C:\Users\lijun\Desktop\project\bayuquan2023\CLIENT01\download\D01_20220714.mp4"

# 打开视频文件
cap = cv2.VideoCapture(url)

# 检查视频是否成功打开
if not cap.isOpened():
    print("Error: Could not open video file.")
    exit()

# 获取视频参数
fps = cap.get(cv2.CAP_PROP_FPS)  # 帧率
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 帧宽度
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 帧高度

# 使用 XVID 编码器（适用于 AVI 格式）
fourcc = cv2.VideoWriter_fourcc(*'XVID')
output_file = "output_video.avi"  # 输出文件路径
out_writer = cv2.VideoWriter(output_file, fourcc, fps, (width, height))

# 检查 VideoWriter 是否成功初始化
if not out_writer.isOpened():
    print("Error: Could not initialize VideoWriter.")
    exit()

# 读取并写入视频帧
while True:
    ret, frame = cap.read()
    if not ret:
        break  # 如果读取失败，退出循环

    # 写入帧
    out_writer.write(frame)

# 释放资源
cap.release()
out_writer.release()
print("Video processing complete.")