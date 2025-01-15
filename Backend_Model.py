import cv2
from PySide6.QtCore import *
from PySide6.QtGui import QImage
import covertQimage as cq


class Backend(QObject):
    myNotified = Signal()
    ImageChanged = Signal(QImage)

    def __init__(self):
        super().__init__()
        self._title_name = "高炉监测测试"
        self._image = QImage()
        self.on_button_clicked()
        self._select_val = 1

    def draw_rectangle(self,image,start_point,end_point,line_lenth=80, color=(255, 0, 0), thickness=5):
        cv2.line(image, start_point, (start_point[0] + line_lenth, start_point[1]), color, thickness)
        cv2.line(image, start_point, (start_point[0], start_point[1] + line_lenth), color, thickness)

        # 绘制右上角十字交叉线
        cv2.line(image, (end_point[0], start_point[1]), (end_point[0] - line_lenth, start_point[1]), color, thickness)
        cv2.line(image, (end_point[0], start_point[1]), (end_point[0], start_point[1] + line_lenth), color, thickness)

        # 绘制左下角十字交叉线
        cv2.line(image, (start_point[0], end_point[1]), (start_point[0] + line_lenth, end_point[1]), color, thickness)
        cv2.line(image, (start_point[0], end_point[1]), (start_point[0], end_point[1] - line_lenth), color, thickness)

        # 绘制右下角十字交叉线
        cv2.line(image, end_point, (end_point[0] - line_lenth, end_point[1]), color, thickness)
        cv2.line(image, end_point, (end_point[0], end_point[1] - line_lenth), color, thickness)
        return image



    @Slot()
    def on_button_clicked(self):
        if not self._image:
            image = cv2.imread('2.jpg')
            image = cv2.resize(image,(1920,1080))

            start_point = (200,200)
            end_point =  (600,600)
            self.draw_rectangle(image,start_point,end_point)
            start_point2 = (800, 200)
            end_point2 = (1200, 600)
            self.draw_rectangle(image, start_point2, end_point2)

            image = cq.ToQImage(image)
            self.image =  image
        else:
            self.image =  QImage()

    @Property(str, notify=myNotified)
    def title_name(self):
        return self._title_name

    @Property(QImage, notify=ImageChanged)
    def image(self):
        return self._image

    @image.setter
    def image(self, image):
        if self._image == image:
            return
        self._image = image
        self.ImageChanged.emit(self._image)

    @Property(int, notify=myNotified)
    def select_val(self):
        return self._select_val

    @select_val.setter
    def select_val(self, value):
        if self._select_val == value:
            return
        self._select_val = value
        self.myNotified.emit()



