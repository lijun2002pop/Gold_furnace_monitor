from sqlalchemy import Column, Integer, String, Float, DateTime, NVARCHAR
from sqlalchemy.orm import sessionmaker,declarative_base
from sqlalchemy import create_engine

# 创建基类
Base = declarative_base()

# 定义 Rec_TempRecord 模型
class Rec_TempRecord(Base):
    __tablename__ = 'Rec_TempRecord'
    id = Column(Integer, primary_key=True, autoincrement=True)
    StationCode = Column(String(10))
    StationName = Column(NVARCHAR(10))
    BlastFurnaceNum = Column(String(10))
    BlastFurnaceAge = Column(String(10))
    AreaName = Column(NVARCHAR(10))
    MaxTemp = Column(Float)
    AvgTemp = Column(Float)
    ImagePath = Column(NVARCHAR(100))
    RecordTime = Column(DateTime)

# 定义 Sys_MonitorArea 模型
class Sys_MonitorArea(Base):
    __tablename__ = 'Sys_MonitorArea'
    id = Column(Integer, primary_key=True, autoincrement=True)
    StationCode = Column(String(100))
    StationName = Column(NVARCHAR(100))
    AreaName = Column(NVARCHAR(100))
    WarnTemp1 = Column(Float,default=0)
    WarnTemp2 = Column(Float,default=0)
    SPointX = Column(Float)
    SPointY = Column(Float)
    EPointX = Column(Float)
    EPointY = Column(Float)
    Remark = Column(NVARCHAR(100))
    RecordTime = Column(DateTime)
    IsDelete = Column(Integer,default=0)

# 定义 Rec_WarnRecord 模型
class Rec_WarnRecord(Base):
    __tablename__ = 'Rec_WarnRecord'
    id = Column(Integer, primary_key=True, autoincrement=True)
    StationCode = Column(String(10))
    StationName = Column(NVARCHAR(10))
    BlastFurnaceNum = Column(String(10))
    BlastFurnaceAge = Column(String(10))
    AreaName = Column(NVARCHAR(10))
    WarnTemp1 = Column(Float)
    WarnTemp2 = Column(Float)
    MaxTemp = Column(Float)
    ImagePath = Column(NVARCHAR(100))
    RecordTime = Column(DateTime)

# 定义 Rec_ExcpRecord 模型
class Rec_ExcpRecord(Base):
    __tablename__ = 'Rec_ExcpRecord'
    id = Column(Integer, primary_key=True, autoincrement=True)
    ExcpType = Column(NVARCHAR(10))
    ExcpInfo = Column(NVARCHAR(50))
    RecordTime = Column(DateTime)

# 定义 Real_BlastFurnaceInfo 模型
class Real_BlastFurnaceInfo(Base):
    __tablename__ = 'Real_BlastFurnaceInfo'
    id = Column(Integer, primary_key=True, autoincrement=True)
    Num = Column(String(10))
    Age = Column(NVARCHAR(10))
    LiningType = Column(NVARCHAR(10))
    InnerTemp = Column(Float)
    InWaterTemp = Column(Float)
    OutWaterTemp = Column(Float)
    WaterPressure = Column(Float)
    WaterAmount = Column(Float)
    OuterTemp = Column(Float)
    AirDuctTemp = Column(Float)
    Temperature = Column(Float)
    ReceiveTime = Column(DateTime)

# 定义 LiningThickness_PreTrain 模型
class LiningThickness_PreTrain(Base):
    __tablename__ = 'LiningThickness_PreTrain'
    id = Column(Integer, primary_key=True, autoincrement=True)
    Num = Column(String(10))
    Age = Column(NVARCHAR(10))
    LiningType = Column(NVARCHAR(10))
    InnerTemp = Column(Float)
    InWaterTemp = Column(Float)
    OutWaterTemp = Column(Float)
    WaterPressure = Column(Float)
    WaterAmount = Column(Float)
    OuterTemp = Column(Float)
    AirDuctTemp = Column(Float)
    LiningThickness = Column(Float)
    Temperature = Column(Float)
    ReceiveTime = Column(DateTime)

# 定义 LiningThickness_PreResult 模型
class LiningThickness_PreResult(Base):
    __tablename__ = 'LiningThickness_PreResult'
    id = Column(Integer, primary_key=True, autoincrement=True)
    Num = Column(String(10))
    Age = Column(NVARCHAR(10))
    LiningType = Column(NVARCHAR(10))
    InnerTemp = Column(Float)
    InWaterTemp = Column(Float)
    OutWaterTemp = Column(Float)
    WaterPressure = Column(Float)
    WaterAmount = Column(Float)
    OuterTemp = Column(Float)
    AirDuctTemp = Column(Float)
    LiningThickness = Column(Float)
    LiningThicknessPre = Column(Float)
    Temperature = Column(Float)
    ReceiveTime = Column(DateTime)
