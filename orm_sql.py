import datetime
import pymssql
import json
import time
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import QueuePool

from orm_model import Rec_TempRecord, Rec_WarnRecord, Rec_ExcpRecord, Sys_MonitorArea

config_path = "configs/config.json"


class Orm_executor:
    failed_count = 0  # 类属性，用于记录失败次数
    def __init__(self):
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        conn = config.get('conn')
        self.engine = create_engine(conn,
                                    poolclass=QueuePool,
                                    pool_size=8,
                                    pool_timeout=5,
                                    pool_recycle=3600)
        self.Session = sessionmaker(bind=self.engine)
        self.session = self.Session()

    def read_config_conn(self):
        with open(self.config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        return config.get('conn')

    # 更新数据库连接状态
    def outwrapper(func):
        def wrapper(self, *args, **kwargs):
            try:
                t1 = time.time()
                result = func(self, *args, **kwargs)
                if time.time() - t1 > 0.3:
                    print(f'数据查询时间-{func.__name__}-{time.time() - t1}')
                return result
            except Exception as e:
                print(f"数据库操作出错: {e}")
                if self.failed_count >= 100:
                    time.sleep(0.5)
                    self.session.close()
                    self.session = self.Session()
                    print('session重连')
                    self.failed_count = 0  # 重连后重置失败次数
                self.failed_count += 1
                return None
        return wrapper

    @staticmethod
    def create_models(db_name='Funrace'):
        # 生成表模型的
        # Orm_executor.create_models()
        import os
        #   pip install sqlalchemy==1.3.24
        #  pip install sqlacodegen==3.0.0b2  指定版本
        # os.system(f'pip install sqlacodegen==3.0.0b2')
        os.system(f'sqlacodegen mssql+pymssql://sa:Anchor.1234@127.0.0.1/{db_name} --outfile test_model.py')

    def _filter_query(self, query, search, starttime, endtime, search_field):
        if search:
            query = query.filter(search_field.like(f"%{search}%"))
        if starttime and endtime:
            query = query.filter(Rec_TempRecord.RecordTime >= starttime,
                                 Rec_TempRecord.RecordTime <= endtime)
        elif starttime:
            query = query.filter(Rec_TempRecord.RecordTime >= starttime)
        elif endtime:
            query = query.filter(Rec_TempRecord.RecordTime <= endtime)
        return query

    @outwrapper
    def Rec_TempRecord_All(self,search="", starttime="", endtime=""):
        query = self.session.query(Rec_TempRecord)
        query = self._filter_query(query, search, starttime, endtime, Rec_TempRecord.StationCode)
        result = query.all()
        formatted_result = []
        for row in result:
            # 将 RecordTime 转换为指定格式的字符串，这里以 '%Y-%m-%d %H:%M:%S' 为例
            record_time_str = row.RecordTime.strftime('%Y-%m-%d %H:%M:%S') if row.RecordTime else None
            avg_temp_str = str(row.MaxTemp)+"℃"
            formatted_row = [row.id, row.StationCode, row.StationName, row.AreaName,
                             avg_temp_str, row.ImagePath, record_time_str]
            formatted_result.append(formatted_row)
        return formatted_result

    @outwrapper
    def Rec_WarnRecord_All(self,search="", starttime="", endtime=""):
        query = self.session.query(Rec_WarnRecord)
        query = self._filter_query(query, search, starttime, endtime, Rec_WarnRecord.StationCode)
        result = query.all()
        formatted_result = []
        for row in result:
            record_time_str = row.RecordTime.strftime('%Y-%m-%d %H:%M:%S') if row.RecordTime else None
            max_temp_str = str(row.MaxTemp) + "℃"
            WarnTemp1 = str(row.WarnTemp1) + "℃"
            WarnTemp2 = str(row.WarnTemp2) + "℃"
            formatted_row = [row.id, row.StationCode, row.StationName,
                             max_temp_str,WarnTemp1,WarnTemp2, row.ImagePath, record_time_str]
            formatted_result.append(formatted_row)
        return formatted_result

    @outwrapper
    def Rec_ExcpRecord_All(self,search="", starttime="", endtime=""):
        query = self.session.query(Rec_ExcpRecord)
        query = self._filter_query(query, search, starttime, endtime, Rec_ExcpRecord.ExcpInfo)
        result = query.all()
        formatted_result = []
        for row in result:
            record_time_str = row.RecordTime.strftime('%Y-%m-%d %H:%M:%S') if row.RecordTime else None
            formatted_row = [row.id,row.ExcpType,'', row.ExcpInfo,record_time_str]
            formatted_result.append(formatted_row)
        return formatted_result

    @outwrapper
    def Sys_MonitorArea_All(self):
        result = self.session.query(Sys_MonitorArea.AreaName,Sys_MonitorArea.WarnTemp1,Sys_MonitorArea.WarnTemp2,
        Sys_MonitorArea.SPointX,Sys_MonitorArea.SPointY,Sys_MonitorArea.EPointX,Sys_MonitorArea.EPointY
                                    ).filter(Sys_MonitorArea.IsDelete==0).all()
        return result

    @outwrapper
    def Sys_MonitorArea_All_delete(self):
        self.session.query(Sys_MonitorArea).filter(Sys_MonitorArea.IsDelete == 0).update({Sys_MonitorArea.IsDelete: 1})
        self.session.commit()

    @outwrapper
    def Sys_MonitorArea_All_add(self,data):
        # 将字典数据转换为模型实例列表
        instances = [Sys_MonitorArea(**item) for item in data]
        # 批量添加数据
        self.session.add_all(instances)
        self.session.commit()

    @outwrapper
    def Sys_MonitorArea_update(self, area_name,temp1,temp2):
        result = self.session.query(Sys_MonitorArea).filter(Sys_MonitorArea.IsDelete == 0,Sys_MonitorArea.AreaName==area_name).first()
        if result:
            result.WarnTemp1 = temp1
            result.WarnTemp2 = temp2
            self.session.commit()
    def close(self):
        try:
            self.session.close()
        except Exception:
            pass

if __name__ == "__main__":
    orm_executor = Orm_executor()
    data = orm_executor.Sys_MonitorArea_update('1#区域',1,2)
    print(data)
    data =('1#区域',10.0,0.0)
    # orm_executor.Sys_MonitorArea_All_add(data)