# -*- coding: utf-8 -*-
from PySide6 import QtCore, QtGui, QtQuick
from PySide6.QtGui import QColor
from PySide6.QtCore import *

import covertQimage


class CVQImage(QtQuick.QQuickPaintedItem):
    imageChanged = QtCore.Signal(QtGui.QImage)

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.m_image = QtGui.QImage()

    def paint(self, painter):
        image = self.m_image
        if not image or image.isNull():
            return
        image = covertQimage.scale(image, self.width(), self.height())
        painter.drawImage(0, 0, image)

        # painter.fillRect(10, 10, 140, 30, QColor(222, 222, 222))
        # font = painter.font()
        # font.setBold(True)
        # font.setPointSize(16)
        # painter.setFont(font)
        # painter.drawText(10, 10, 140, 30, 0x84, self.m_desc)

    @Property(QtGui.QImage, notify=imageChanged)
    def image(self):
        return self.m_image

    @image.setter
    def image(self, image):
        if self.m_image == image:
            return
        self.m_image = image
        self.update()
        self.imageChanged.emit(self.m_image)

    # image = QtCore.Property(QtGui.QImage, fget=get_image, fset=set_image, notify=imageChanged)
    # desc = QtCore.Property(str, fget=get_desc, fset=set_desc)