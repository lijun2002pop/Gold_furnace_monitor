# -*- coding: utf-8 -*-
import cv2
from PySide6 import QtGui, QtCore
import numpy


gray_color_table = [QtGui.qRgb(i, i, i) for i in range(256)]


def get_color_len(shape):
    if len(shape) == 3:
        return shape[2]
    else:
        return 1

def get2GrayType(shape):
    color_len = get_color_len(shape)
    if color_len == 3:
        return cv2.COLOR_BGR2GRAY
    if color_len == 4:
        return cv2.COLOR_BGRA2GRAY
    return None

def ToQImage(im):
    if im is None:
        return QtGui.QImage()
    if im.dtype != numpy.uint8:
        return QtGui.QImage()
    qim = None
    if len(im.shape) == 2:
        w, h = im.shape
        # im = cv2.equalizeHist(im)
        qim = QtGui.QImage(im.data, h, w, im.strides[0], QtGui.QImage.Format_Indexed8)
        qim.setColorTable(gray_color_table)
    elif len(im.shape) == 3:
        w, h, d = im.shape
        if d == 3:
            rgb_image = cv2.cvtColor(im, cv2.COLOR_BGR2RGB)
            qim = QtGui.QImage(rgb_image, h, w, QtGui.QImage.Format_RGB888)
        elif d == 4:
            rgb_image = cv2.cvtColor(im, cv2.COLOR_BGRA2RGB)
            # flip_image = cv2.flip(rgb_image, 1)
            qim = QtGui.QImage(rgb_image, h, w, QtGui.QImage.Format_RGB888)
        elif d == 1:
            qim = QtGui.QImage(im.data, h, w, QtGui.QImage.Format_Indexed8)
            qim.setColorTable(gray_color_table)
    if qim is not None:
        return qim.copy()
    return QtGui.QImage()

def scale(image, width, height):
    # if top_import_manager.is_config_scale_tight():
    #     w_ratio = width / image.width()
    #     h_ratio = height / image.height()
    #     if w_ratio > h_ratio:
    #         size = QtCore.QSize(image.width() * h_ratio, height)
    #     else:
    #         size = QtCore.QSize(width, image.height() * w_ratio)
    # else:
    #     size = QtCore.QSize(width, height)
    size = QtCore.QSize(width, height)
    return image.scaled(size)
