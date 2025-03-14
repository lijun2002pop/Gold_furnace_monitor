import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import PyCVQML 1.0 as Pycv

Window {
    id: windows
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr(backend.title_name)
    Component.onCompleted: backend.threadstart()
    onClosing: backend.threadstop()
    FluInfoBar {
        id: infoBar
        root: windows
    }
    DateTimePicker {
        id:date
        visible:false
    }
    ImgShow{
        id:imgshow
        visible:false
        imgpath:""
    }
    //背景图片
     Image{
        id: bg_body
        fillMode: Image.Stretch
        width:windows.width
        height:windows.height
        anchors.centerIn: parent
        smooth: true
        source: '../Source/Images/bg.png'
    }
    // 导航条
    HeadMenu {
        id: head
        width: parent.width
        height: parent.height *0.1
    }
    Rectangle {
        color: "transparent"
        anchors {
            top: head.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin:parent.height*0.01
            bottomMargin:parent.width*0.03
            leftMargin:parent.width*0.03
            rightMargin:parent.width*0.03
        }
        width: parent.width
        height:  parent.height *0.9
        Rectangle {
            anchors.fill: parent
            id: homePage
            visible: backend.pageindex == 0
            color: "transparent"

            Layout.fillWidth: true
            Layout.fillHeight: true
            Image {
                anchors.fill: parent
                smooth: true
                source: "../Source/Images/imgrect.png"
                Pycv.CVQImage{
                    anchors.margins:5
                    anchors.fill:parent
                    image:backend.camera.drawimage
                }
            }
        }
        //系统配置
        Rectangle {
            anchors.fill: parent
            id: systemConfigPage
            visible: backend.pageindex == 1
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Row {
                anchors.fill: parent
                spacing: 5
                Rectangle {
                    color: "transparent"
                    width: parent.width*0.3
                    height: parent.height
                    SystemConfig{
                    }
                }
                Rectangle {
                    color: "transparent"
                    width: parent.width*0.7
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        smooth: true
                        source: "../Source/Images/imgrect.png"
                        Pycv.CVQImage{
                            anchors.margins: 5
                            anchors.fill:parent
                            image:backend.camera.drawselectedimage
                        }
                    }
                }
            }
        }
        //温度监测记录
        Rectangle {
            anchors.fill: parent
            id: temp
            visible: backend.pageindex == 2
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            TempData{
            }
        }
        //报警数据记录
        Rectangle {
            anchors.fill: parent
            id: warn
            visible: backend.pageindex == 3
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            WarnData{
            }
        }
        //异常数据记录
        Rectangle {
            anchors.fill: parent
            id: err
            visible: backend.pageindex == 4
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            ErrData{
            }
        }
        //温度曲线
        Rectangle {
            anchors.fill: parent
            id: linechartPage
            visible: backend.pageindex == 5
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            LineCharts{
            }
        }
        //炉衬厚度预测
        Rectangle {
            anchors.fill: parent
            id: thickness
            visible: backend.pageindex == 6
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            ThickData{
            }
        }
        Rectangle {
            anchors.fill: parent
            id: chartPage
            visible: backend.pageindex == 7
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            PageCharts{
            }
        }
    }
}