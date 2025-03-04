import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import FluentUI

Rectangle {
    id: grid
    width: parent.width
    height: parent.height
    color: 'transparent'
    function get_save_config(){
        var result =  backend.get_save_config()
        interval_id.text = result[0];
        save.text = result[1];
    }
    //路径选择
    FolderDialog {
        id: folderDialog
        options: FolderDialog.ShowDirsOnly
        onAccepted: {
            save.text = selectedFolder
        }
    }
    DrawImg{
        id:newwindow
        visible:false
    }
    Image {
        anchors.fill: parent
        smooth: true
        source: "../Source/grid.png"
    }
    ColumnLayout {
        anchors.margins: 10
        anchors.fill: parent
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height *0.3
            Rectangle {
                id:carameid
                color: "transparent"
                width:parent.width
                height:parent.height *0.3
                anchors.top: parent.top
                anchors.topMargin:parent.height *0.1
                RowLayout {
                    anchors.fill: parent
                    Label {
                        id:selectcarame
                        width: parent.width*0.1
                        text: "选择相机："
                        font.bold: true
                        font.pixelSize:height
                    }
                    FluComboBox {
                        width: parent.width*0.3
                        anchors.left: selectcarame.right
                        id: cameraComboBox
                        model: [backend.camera.name, ]
                    }
                }
            }

            Rectangle {
                anchors.top:carameid.bottom
                color: "transparent"
                width:parent.width
                height:parent.height *0.5
                Row {

                    width:parent.width
                    height:parent.height
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width *0.4
                        height: parent.height*0.6
                        smooth: true
                        source: "../Source/grid.png"

                        Label {
                            id:area
                            anchors.centerIn: parent
                            font.bold: true
                            text: "绘制区域"
                            color:"#FFB6F6FF"
                            font.pixelSize:width*0.4
                        }
                    }
                    Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width *0.6
                    height: parent.height*0.6
                    smooth: true
                    source: "../Source/grid.png"
                    Row {
                        height: parent.height
                        width: parent.width
                        FluIcon{
                            id:iconmouse
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left:parent.left
                            anchors.leftMargin:parent.width *0.3
                            iconSource:FluentIcons.ClickSolid
                            iconSize:parent.height *0.45
                            color:"#FFB6F6FF"
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{

                                }

                            }
                        }
                        FluIcon{
                            id:iconrect
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left:iconmouse.right
                            anchors.leftMargin:parent.width *0.2
                            iconSource:FluentIcons.Checkbox14
                            iconSize:parent.height *0.45
                            color:"#FFB6F6FF"
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    newwindow.rectangles = backend.camera.get_areas_rect()
                                    newwindow.visible = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ColumnLayout{
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height *0.35
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            Rectangle {
                id:areaid
                color: "transparent"
                width:parent.width
                height:parent.height *0.3
                anchors.top: parent.top
                anchors.topMargin:parent.height *0.05
            RowLayout {
                        anchors.fill: parent
                        Label {
                            id:selectarea
                            width: parent.width*0.1
                            text: "选择区域："
                            font.bold: true
                            font.pixelSize:height
                        }
                        FluComboBox {
                            id:area_id
                            width: parent.width*0.3
                            anchors.left: selectarea.right
                            model: backend.camera.get_areas_name()
                            function update_temp(){
                                var result =  backend.camera.get_areas_temp(currentValue)
                                dtemp.text = result[0];
                                wtemp.text = result[1];
                            }
                            // 更新数据
                            onActivated: {
                                update_temp()
                            }
                            Component.onCompleted: {
                                update_temp()
                                get_save_config()
                            }
                        }
                    }
                }
        Rectangle {
                anchors.top:areaid.bottom
                color: "transparent"
                width:parent.width
                height:parent.height *0.6
                Row {
                    width:parent.width
                    height:parent.height
                    Image {
                        id:warnimg
                        width: parent.width *0.4
                        height: parent.height
                        smooth: true
                        source: "../Source/grid.png"

                        Label {
                            anchors.centerIn: parent
                            font.bold: true
                            text: "报 警 \n配 置"
                            color:"#FFB6F6FF"
                            font.pixelSize:area.font.pixelSize
                        }
                    }
                    Rectangle {
                        width:parent.width *0.6
                        height:parent.height
                        anchors.left:warnimg.right
                        color:'transparent'
                        Image {
                            id:communwarn
                            width: parent.width
                            height: parent.height*0.33
                            smooth: true
                            source: "../Source/grid.png"
                            RowLayout {
                                anchors.centerIn: parent
                                Text {
                                    text: "一般报警下限：>="
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                                FluTextBox {
                                    cleanEnabled:false
                                    id: dtemp
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: parent.width *0.4
                                    text: "25.0"
                                    color:"red"
                                }
                                Text {
                                    text: "°C"
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                            }
                        }
                        Image {
                            id:warner
                            anchors.top:communwarn.bottom
                            width: parent.width
                            height: parent.height*0.33
                            smooth: true
                            source: "../Source/grid.png"
                            RowLayout {
                                anchors.centerIn: parent
                                Text {
                                    text: "严重报警下限：>="
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                                FluTextBox {
                                    id:wtemp
                                    cleanEnabled:false
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: parent.width *0.4
                                    text: "50.0"
                                    color:"red"
                                }
                                Text {
                                    text: "°C"
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                            }
                        }
                        Rectangle {
                            anchors.top:warner.bottom
                            width: parent.width
                            height: parent.height*0.34
                            color:"#A90863FF"

                            Label {
                                text: "保存"
                                font.pixelSize: parent.height * 0.4
                                color: "white"
                                anchors.centerIn: parent

                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    var res = backend.camera.save_temp(area_id.currentValue,dtemp.text,wtemp.text)
                                    if(res){infoBar.showSuccess("保存成功")}
                                }
                            }
                        }
                    }
                }

            }
        }
    }
    ColumnLayout{
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height *0.35
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
                 Row {
                    width:parent.width
                    height:parent.height*0.8
                    anchors.top: parent.top
                    anchors.topMargin:parent.height *0.1
                    Image {
                        id:datacatch
                        width: parent.width *0.4
                        height: parent.height
                        smooth: true
                        source: "../Source/grid.png"
                        Label {
                            anchors.centerIn: parent
                            font.bold: true
                            text: "数 据\n抓 拍"
                            color:"#FFB6F6FF"
                            font.pixelSize:area.font.pixelSize
                        }
                    }
                    Rectangle {
                        width:parent.width *0.6
                        height:parent.height
                        anchors.left:datacatch.right
                        color:'transparent'
                        Image {
                            id:timeinterval
                            width: parent.width
                            height: parent.height*0.25
                            smooth: true
                            source: "../Source/grid.png"
                            RowLayout {
                                anchors.centerIn: parent
                                Text {
                                    text: "存储间隔："
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                                FluTextBox {
                                    id:interval_id
                                    cleanEnabled:false
                                    Layout.fillWidth: true
                                    Layout.preferredWidth:save.width
                                    text: "30"
                                    color:"green"
                                }
                                Text {
                                    text: "（S）"
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                            }
                        }
                        Image {
                            id:savepath
                            anchors.top:timeinterval.bottom
                            width: parent.width
                            height: parent.height*0.25
                            smooth: true
                            source: "../Source/grid.png"
                            RowLayout {
                                anchors.centerIn: parent
                                Text {
                                    text: "存储路径："
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                                FluTextBox {
                                    id:save
                                    cleanEnabled:false
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: parent.width * 0.3
                                    Layout.maximumWidth: parent.width * 0.6
                                    text: ""
                                    color:"green"
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            folderDialog.open()
                                        }
                                    }
                                }
                                Text {
                                    text: "（P）"
                                    font.bold: true
                                    color:"#FFB6F6FF"
                                }
                            }
                        }
                        Rectangle {
                            id:savebtn
                            anchors.top:savepath.bottom
                            width: parent.width
                            height: parent.height*0.25
                            color:"#A90863FF"
                            Label {
                                text: "保存"
                                font.pixelSize: parent.height * 0.4
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    var res = backend.set_save_config( interval_id.text,save.text)
                                    if(res){infoBar.showSuccess("保存成功")}
                                }
                            }
                        }
                        Row{
                            width:parent.width
                            height:parent.height*0.25
                            anchors.top: savebtn.bottom
                            Image {
                                width: parent.width *0.5
                                height: parent.height
                                smooth: true
                                source: "../Source/grid.png"
                                RowLayout {
                                    anchors.centerIn: parent
                                    Text {
                                        text: "拍照"
                                        font.bold: true
                                        color:"#FFB6F6FF"
                                    }
                                    FluIcon{
                                        id:catchpic
                                        anchors.verticalCenter: parent.verticalCenter
                                        iconSource:FluentIcons.Camera
                                        iconSize:parent.height
                                        color:"#FFB6F6FF"
                                        Timer {
                                                id: colorTimer
                                                interval: 150
                                                running: false
                                                repeat: false
                                                onTriggered: {
                                                    catchpic.color="#FFB6F6FF"
                                                }
                                            }
                                         MouseArea{
                                            anchors.fill: parent
                                            onClicked:{
                                                        backend.camera.take_photo()
                                                        catchpic.color="red"
                                                       colorTimer.start() }
                                        }
                                    }
                                }
                            }
                            Image {
                                width: parent.width *0.5
                                height: parent.height
                                smooth: true
                                source: "../Source/grid.png"
                                RowLayout {
                                    anchors.centerIn: parent
                                    Text {
                                        text: "录像"
                                        font.bold: true
                                        color:"#FFB6F6FF"
                                    }
                                    FluIcon{
                                        id:catchvideo
                                        anchors.verticalCenter: parent.verticalCenter
                                        iconSource:FluentIcons.PresenceChickletVideo
                                        iconSize:parent.height
                                        color:"#FFB6F6FF"
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked:{
                                                        backend.camera.take_video()
                                                        catchvideo.color =catchvideo.color=="#b6f6ff"?"red":"#b6f6ff"}
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }
    }

    }
 }