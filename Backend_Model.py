import json
import time

import cv2
from PySide6.QtCore import *
from PySide6.QtGui import QImage,QWindow
import covertQimage as cq
from Tran_Model import TableRecord, LineChart, PageChart, CameraInfo, CameraAreaInfo
from container.main_capture import MainCapture
from orm_sql import Orm_executor, config_path
from tools import py_common_utils


class Backend(QObject):
    myNotified = Signal()
    ImageChanged = Signal(QImage)

    def __init__(self,):
        super().__init__()
        self.stopped = False
        with open(config_path, 'r', encoding='utf-8') as f:
            self.config = json.load(f)
        self.parent_obj = QWindow()
        self._title_name = self.config.get('title-name')
        self.save_path = self.config.get('save-path')
        self.save_interval = self.config.get('save-interval')
        self.sql_orm_executor = Orm_executor()

        self._pageindex = 0
        self._search_objects = {}
        self.count = 1
        self.init_table_data()
        self.init_chart_data()
        self.Camera = CameraInfo(self,)
        # 数据变动
        self.dbtimer = QTimer(self)
        self.dbtimer.timeout.connect(self.update_chart_data)
        self.dbtimer.start(1000)
        self._handlers = [
            MainCapture(self,),

        ]


    def init_table_data(self):
        # 温度记录
        flag = "temp"
        self._temp = TableRecord(self, flag)
        self._search_objects[flag] = self._temp
        # 报警记录
        flag = "warn"
        self._warn = TableRecord(self, flag, )
        self._search_objects[flag] = self._warn
        # 异常记录
        flag = "err"
        self._err = TableRecord(self, flag, )
        self._search_objects[flag] = self._err

        flag = "thick"
        self._thick = TableRecord(self, flag, )
        self._search_objects[flag] = self._thick

    def init_chart_data(self):
        xdata = ['1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', '12:00']
        ydata = [65, 59, 80, 81, 56, 55, 45,77, 90, 80, 50,99]
        flag = "linechart"
        self._linechart = LineChart(self,flag,xdata,ydata)
        self._search_objects[flag] = self._linechart

        warn_data = [500,10,5]
        err_data = [2,1,3]
        self._pagechart = PageChart(self,warn_data,err_data)

    def update_chart_data(self):
        self.count += 20
        ydata = [1 + self.count, 100 - self.count, 80, 81, 56, 55, 45, 77, 90, 80, 50, 99, 80, 81, 56, 55, 45, 77, 90,
                 80, 50, 99]
        xdata = ['1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00',
                 '9:00', '10:00', '11:00', '12:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00',
                 '9:00', '10:00', '11:00', '12:00']
        self._linechart.update_line_chart(xdata, ydata)

        warn_data = [500-self.count, 10, 5]
        err_data = [2, 1+self.count, 3]
        self._pagechart.update_chart(warn_data,err_data)
        self.myNotified.emit()

    @Slot(str,str)
    def to_search(self,type,search):
        print(type,search)
        obj = self._search_objects.get(type)
        if obj:
            obj.update_search(search)
            obj.update()

    @Slot(str, str, str )
    def update_page(self, type, page, count):
        obj = self._search_objects.get(type)
        if obj:
            obj.update_page(page,count)
            obj.update()

    @Property(str, notify=myNotified)
    def title_name(self):
        return self._title_name

    @Slot(result=list)
    def get_save_config(self):
        # last_path  =self.save_path.split('/')[-1]
        # if last_path:
        #     return "/"+last_path
        return [self.save_interval,self.save_path]

    @Slot(int,str,result=bool)
    def set_save_config(self,save_interval,save_path):
        save_path = save_path.replace("file:///", "")
        if self.save_interval != save_interval or self.save_path != save_path:
            self.save_interval = save_interval
            self.save_path = save_path
            with open(config_path, 'r', encoding='utf-8') as f:
                config = json.load(f)
            config['save-path'] = save_path
            config['save-interval'] = save_interval
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, ensure_ascii=False, indent=4)
        return True

    @Property(int, notify=myNotified)
    def pageindex(self):
        return self._pageindex

    @pageindex.setter
    def pageindex(self, value):
        if self._pageindex == value:
            return
        self.change_index(value)
        self._pageindex = value
        self.myNotified.emit()

    @Property("QVariant", notify=myNotified)
    def temp(self):
        return self._temp

    @Property("QVariant", notify=myNotified)
    def warn(self):
        return self._warn

    @Property("QVariant", notify=myNotified)
    def err(self):
        return self._err

    @Property("QVariant", notify=myNotified)
    def thick(self):
        return self._thick

    @Property("QVariant", notify=myNotified)
    def camera(self):
        return self.Camera

    @Property("QVariant", notify=myNotified)
    def linechart(self):
        return self._linechart

    @Property("QVariant", notify=myNotified)
    def pagechart(self):
        return self._pagechart

    def change_index(self,index):
        if index == 2:
            self._temp.reset()
        elif index == 3:
            self._warn.reset()
        elif index == 4:
            self._err.reset()
        elif index == 6:
            self._err.reset()

    @Slot()
    def threadstart(self):
        for handler in self._handlers:
            handler.start()

    @Slot()
    def threadstop(self):
        self.stopped = True
        time.sleep(0.03)
        while True:
            running = False
            for handler in self._handlers:
                if hasattr(handler, 'available'):
                    if handler.available():
                        running = True
                        time.sleep(0.1)
                        break
            if running:
                continue
            if not running:
                break
        py_common_utils.dump_traces()
