import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI

Rectangle   {
    id: grid
    width: parent.width
    height: parent.height
    color: 'transparent'
    RowLayout {
        id: mainLayout
        anchors.fill: parent
        // 左侧图片区域
        Rectangle {
            id: imageContainer
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.36
            color: 'transparent'
            RowLayout {
                anchors.fill: parent
                  Text{
                        text:backend.title_name
                        color:'#0099ff'
                        font.pixelSize:26
                        font.bold:true
                        anchors.centerIn: parent
                    }
            }
        }

        // 右侧按钮区域
        Rectangle {
            id: buttonContainer
            Layout.preferredHeight: parent.height * 0.85
            Layout.preferredWidth: parent.width * 0.58
            color: 'transparent'
            RowLayout {
                anchors.fill: parent
                Image {
                    id: indexpage
                    Layout.preferredWidth: parent.width * 0.1
                    Layout.preferredHeight: parent.height * 0.6
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 0
                    }
                    Text {
                        id: indexfont
                        text: "首页"
                        font.pixelSize: parent.width * 0.13
                        color:  backend.pageindex == 0? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.1
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 1
                    }
                    Text {
                        text: "系统配置"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 1? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.12
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 2
                    }
                    Text {
                        text: "温度监测记录"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 2? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.12
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 3
                    }
                    Text {
                        text: "报警数据记录"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 3? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.12
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 4
                    }
                    Text {
                        text: "异常数据记录"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 4? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.1
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 5
                    }
                    Text {
                        text: "温度曲线"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 5? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.12
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 6
                    }
                    Text {
                        text: "炉衬厚度预测"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 6? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
                Image {
                    Layout.preferredWidth: parent.width * 0.1
                    Layout.preferredHeight: indexpage.height
                    Layout.alignment: Qt.AlignVCenter  // 垂直居中
                    smooth: true
                    source: "../Source/btn.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:  backend.pageindex = 7
                    }
                    Text {
                        text: "数据报表"
                        font.pixelSize: indexfont.font.pixelSize
                        color:  backend.pageindex == 7? '#FF2DDBFF' : 'white'
                        anchors.centerIn: parent
                    }
                }
            }
        }
        // 右侧图片区域
        Rectangle {
            id: rightimg
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.04
            color: 'transparent'
            FluIcon{
                anchors.left: buttonContainer.right
                anchors.verticalCenter: parent.verticalCenter
                iconSource: FluentIcons.PowerButton
                iconSize:parent.height*0.2
                iconColor:"#0099ff"
                MouseArea{
                    anchors.fill: parent
                    onClicked:windows.close()
                }
            }
        }
    }
}