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
    FluInfoBar {
        id: infoBar
        root: windows
    }
    DateTimePicker {
        id:date
        visible:false
    }
    // 导航条
    HeadMenu {
        id: head
        width: parent.width
        height: 60
    }
    Rectangle {
        width: parent.width
        height: parent.height - head.height
        anchors.top: head.bottom
        Item  {
            id: layout
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent

                id: homePage
                visible: backend.pageindex == 0

                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Image {
                    anchors.margins: 5
                    anchors.fill: parent
                    smooth: true
                    source: "../Source/logokuang.png"
                    Pycv.CVQImage{
                        anchors.margins: 5
                        anchors.fill:parent
                        image:backend.image
                    }
                }
            }
            //系统配置
            Rectangle {
                anchors.fill: parent

                id: systemConfigPage
                visible: backend.pageindex == 1

                color: "lightblue"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Row {
                    anchors.fill: parent
                    anchors.margins: 5
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
                            anchors.rightMargin:5
                            anchors.fill: parent
                            smooth: true
                            source: "../Source/logokuang.png"
                            Pycv.CVQImage{
                                anchors.margins: 5
                                anchors.fill:parent
                                image:backend.image
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
                color: "lightyellow"
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
                color: "lightyellow"
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

                color: "lightyellow"
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
                color: "lightgreen"
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
                color: "lightyellow"
                Layout.fillWidth: true
                Layout.fillHeight: true
                ThickData{
                }
            }
            Rectangle {
                anchors.fill: parent

                id: chartPage
                visible: backend.pageindex == 7

                color: "lightgreen"
                Layout.fillWidth: true
                Layout.fillHeight: true
                PageCharts{
                }
            }
        }
    }

}