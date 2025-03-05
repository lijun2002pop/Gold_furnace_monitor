import datetime
import json
import os

import covertQimage as cq

import cv2
from PySide6.QtCore import QObject, Property, Signal, Slot


#表格
from PySide6.QtGui import QImage


class TableRecord(QObject):
    myNotified = Signal()
    PageChanged = Signal()
    def __init__(self,backend,flag,data=None):
        super().__init__(backend.parent_obj)
        self.sql_orm_executor = backend.sql_orm_executor
        self._flag = flag
        #条件查询
        self.reset()

    def reset(self):
        # 双向绑定 显示用
        self._startdate = ''
        self._enddate = ''

        self._start = ""
        self._end = ""
        self._search = ''
        self._data = self.get_data()
        # 分页
        self._length = len(self._data)
        self._page = 1
        self.total = 10

        self.page = 1


    def get_data(self):
        if self.flag == "temp":
            result = self.sql_orm_executor.Rec_TempRecord_All(self._search, self._start, self._end)
        elif self.flag == "warn":
            result = self.sql_orm_executor.Rec_WarnRecord_All(self._search, self._start, self._end)
        elif self.flag == "err":
            result = self.sql_orm_executor.Rec_ExcpRecord_All(self._search, self._start, self._end)
        elif self.flag == "thick":
            result = [
            ["1", "1#", "******", "360", "高炉炉体内侧", "300℃", "***", "2025-2-6 1:00:00"],
            ["2", "1#", "******", "360", "高炉炉体外侧", "500℃", "***", "2025-2-6 1:00:00"],
        ]
        else:
            result=[]
        return result

    @Property("QVariantList", notify=myNotified)
    def data(self) :
        start_index = (self._page - 1) * self.total
        end_index = min(start_index + self.total, self._length)
        return self._data[start_index:end_index]


    @data.setter
    def data(self, value):
        self._data = value
        self.myNotified.emit()


    @Property(str, notify=myNotified)
    def startdate(self):
        return self._startdate


    @startdate.setter
    def startdate(self, value):
        print('set--',value)
        self._startdate = value
        self.myNotified.emit()


    @Property(str, notify=myNotified)
    def enddate(self):
        return self._enddate


    @enddate.setter
    def enddate(self, value):
        print('setenddate--',value)
        self._enddate = value
        self.myNotified.emit()

    @Property(str, notify=myNotified)
    def flag(self):
        return self._flag


    @Property(int, notify=myNotified)
    def length(self):
        return self._length


    @length.setter
    def length(self, value):
        self._length = value
        self.myNotified.emit()


    @Property(int, notify=myNotified)
    def page(self):
        return self._page


    @page.setter
    def page(self, value):
        self._page = int(value)
        self.myNotified.emit()
        self.PageChanged.emit()



    def update_search(self,search):
        self._search= search
        self._start = self._startdate
        self._end = self._enddate
        self.data = self.get_data()
        self.page = 1




    def update_page(self,page, count):
        total_page =  (self._length + self.total - 1) // self.total
        if int(page) > total_page:
            return
        self.page = page


    def update(self):
        self.length = len(self._data)
        self.myNotified.emit()


#折线图
class LineChart(TableRecord):
    linechartChanged = Signal()
    def __init__(self, parent, flag, xdata=None, ydata=None):
        super().__init__(parent,flag)
        self.linedata = {
            "xdata": xdata,
            "ydata": ydata,
        }
    @Property("QVariantList", notify=linechartChanged)
    def xdata(self) :
        return self.linedata.get('xdata')


    @Property("QVariantList", notify=linechartChanged)
    def ydata(self):
        return self.linedata.get('ydata')


    def update_line_chart(self, xdata,ydata):
        self.linedata["xdata"]=xdata
        self.linedata["ydata"]=ydata
        self.linechartChanged.emit()

#数据报表
class PageChart(QObject):
    pagechartChanged = Signal()
    def __init__(self,parent,warn_data=None,err_data=None):
        super().__init__(parent)
        self.chartdata = {
            "warn_data": warn_data,
            "err_data": err_data,
        }

    @Property("QVariantList", notify=pagechartChanged)
    def warn_data(self) :
        return self.chartdata.get('warn_data')

    @Property("QVariantList", notify=pagechartChanged)
    def err_data(self) :
        return self.chartdata.get('err_data')

    def update_chart(self, xdata,ydata):
        self.chartdata["warn_data"]=xdata
        self.chartdata["err_data"]=ydata
        self.pagechartChanged.emit()


#相机配置信息
class CameraInfo(QObject):
    ImageChanged = Signal(QImage)
    myNotified = Signal()
    def __init__(self,backend,name = "1#相机"):
        super().__init__(backend.parent_obj)
        self.backend = backend
        self.sql_orm_executor = backend.sql_orm_executor
        self._name = name
        self.code = "101"
        self.areas = []
        self._image =  None
        self._cached_drawimage = None  # 缓存处理后的图像
        self.init_config_Area()
        self.take_video_start = False

    @Slot(result=str)
    def take_photo(self):
        #抓拍
        screenshot_path = os.path.join(self.backend.save_path, 'screenshot_{}.png'.format(datetime.datetime.now().strftime('%Y%m%d_%H%M%S')))
        cv2.imwrite(screenshot_path, self._image)
        return screenshot_path

    @Slot(result=str)
    def take_video(self):
        #录像
        self.take_video_start = True
        main_capture = self.backend._handlers[0]
        if main_capture.is_recording and main_capture.output_file:
            return main_capture.output_file
        return None


    @Property(QImage, notify=ImageChanged)
    def image(self):
        return cq.ToQImage(self._image)

    @image.setter
    def image(self, image):
        if image is None:
            return
        self._image = image
        self._cached_drawimage = None  # 清空缓存
        self.ImageChanged.emit(self._image)

    @Property(QImage, notify=ImageChanged)
    def drawimage(self):
        if self._image is None:
            return None
        if self._cached_drawimage is None:  # 如果缓存为空，重新绘制
            image = self._image.copy()  # 创建图像的副本
            for index, item in enumerate(self.get_draw_rect()):
                image = self.draw_rectangle(index, image, item[0], item[1])
            self._cached_drawimage = image  # 缓存处理后的图像
        return cq.ToQImage(self._cached_drawimage)

    @Property(str, notify=myNotified)
    def name(self):
        return self._name

    @Slot(str,result=list)
    def get_areas_temp(self,area_name):
        for area in self.areas:
            if area.name == area_name:
                return [area.temp1,area.temp2]
        return [0,0]

    @Slot(str,float,float,result=bool)
    def save_temp(self, area_name,temp1,temp2):
        self.sql_orm_executor.Sys_MonitorArea_update(area_name,temp1,temp2)
        for area in self.areas:
            if area.name == area_name:
                area.temp1 = temp1
                area.temp2 = temp2
        return True

    def init_config_Area(self):
        # 获取相机的区域
        self.clear()
        res = self.sql_orm_executor.Sys_MonitorArea_All()
        for item in res:
            self.add_area(CameraAreaInfo(*item))

    def draw_rectangle(self,index,image,start_point,end_point,line_lenth=20, color=(0, 0, 255), thickness=2):
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

        # 区域名
        cv2.putText(image, "Ar%s"%(index+1), (start_point[0], start_point[1] + 15), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 0, 0), 1, cv2.LINE_AA)

        return image

    def add_area(self, area):
        """添加一个区域到相机"""
        self.areas.append(area)

    def clear(self,):
        self.areas = []

    def areas_rect(self):
        result = []
        for area in self.areas:
            result.append(area.get_coordinates())
        return result

    @Slot(result=list)
    def get_areas_name(self):

        result = []
        for area in self.areas:
            result.append(area.name)
        return result

    @Slot(result=list)
    def get_areas_rect(self):
        """根据区域名称获取区域"""
        result = []
        for area in self.areas:
            result.append(area.get_coordinates())
        return result

    def get_draw_rect(self):
        result = []
        for area in self.areas:
            result.append(area.get_rect())
        return result

    @Slot(str,str,str)
    def save_draw(self,data,temp1,temp2):
        try:
            temp1 = float(temp1)
            temp2 = float(temp2)
        except Exception as e:
            temp1 = temp2 = 0
        # 解析 JSON 数据
        rectangles = json.loads(data)
        # 提取 x, y, x1, y1
        result = []
        for i in range(len(rectangles)):
            rect = rectangles[i]
            x = rect["x"]
            y = rect["y"]
            x1 = x + rect["width"]
            y1 = y + rect["height"]
            WarnTemp1 = temp1
            WarnTemp2 = temp2
            StationCode = self.backend.Camera.code
            StationName = self.backend.Camera.name
            AreaName = '%d#区域'%(i+1)
            RecordTime = datetime.datetime.now()
            result.append({"SPointX": x, "SPointY": y, "EPointX": x1, "EPointY": y1,"WarnTemp1":WarnTemp1,"WarnTemp2":WarnTemp2,
                           "StationCode":StationCode,"StationName":StationName,"AreaName":AreaName,"RecordTime":RecordTime})
        #删除原区域
        self.sql_orm_executor.Sys_MonitorArea_All_delete()
        #添加新区域
        self.sql_orm_executor.Sys_MonitorArea_All_add(result)
        #重载区域
        self.init_config_Area()
        self.myNotified.emit()




#相机区域配置
class CameraAreaInfo():
    def __init__(self, name, temp1, temp2, x, y, x2, y2):
        super().__init__()
        self.name = name  # 区域名称
        self.temp1 = temp1
        self.temp2 = temp2
        self.x = x  # 区域左上角 x 坐标
        self.y = y  # 区域左上角 y 坐标
        self.x2 = x2  # 区域右下角 x 坐标
        self.y2 = y2  # 区域右下角 y 坐标

    def get_rect(self):
        return [(int(self.x),int(self.y)),(int(self.x2),int(self.y2))]

    def get_coordinates(self):
        """获取区域的坐标信息"""
        return {"x":self.x,"y": self.y,"width": self.x2 - self.x, "height":self.y2-self.y}

    def update_temperature(self, max_temp, avg_temp):
        """更新区域的温度信息"""
        self.max_temp = max_temp
        self.avg_temp = avg_temp



