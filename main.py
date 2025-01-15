import sys

import FluentUI
from PySide6.QtCore import *
from PySide6.QtGui import QGuiApplication, QAction
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from Backend_Model import Backend
import CvImage as cV

# 窗口类，继承自 QObject
class MyWindow(QObject):
    def __init__(self):  # 构造函数
        super().__init__()  # 继承父类
        # 参数，1：类，2.qml导入包名，3:版本，4:版本号，5:qml控件名
        qmlRegisterType(cV.CVQImage, "PyCVQML", 1, 0, "CVQImage")  # 将画图注册到qml中
        self.engine = QQmlApplicationEngine()  # 申明qml加载引擎
        FluentUI.init(self.engine)
        self.backend = Backend()
        # 将Backend类注册到qml，backend是qml中的Backend类的实例化
        self.engine.rootContext().setContextProperty("backend", self.backend)
        qml = "resource/main.qml"
        self.engine.load(QUrl.fromLocalFile(qml))  # 加载qml


if __name__ == "__main__":
    app = QGuiApplication().instance()
    if app is None:
        app = QGuiApplication(sys.argv)
    window = MyWindow()
    result = app.exec()
    sys.exit(result)