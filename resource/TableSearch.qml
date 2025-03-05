import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Rectangle {
    width: parent.width *0.6
    height: parent.height
    color: "transparent"  // 背景颜色
    anchors.left: parent.left
    RowLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 5
        // 标签和下拉框
        RowLayout {
            spacing: 5
            Label {
                text: "开始时间:"
                color: "#0099ff"
                font.pixelSize: parent.height *0.6
            }
            FluFilledButton{
                Layout.preferredWidth: parent.width *0.38

                text:obj.startdate?obj.startdate:"请选择开始时间"
                onClicked: {
                    date.visible= true
                    date.flag= 'start'
                    date.obj= obj
                    date.selectedDateTime = obj.startdate? new Date(obj.startdate):new Date()
                }
            }

            Label {
                text: "-"
                color: "white"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }
            FluFilledButton{
                Layout.preferredWidth: parent.width *0.38
                text:obj.enddate?obj.enddate:"请选择结束时间"
                onClicked: {
                    date.visible= true
                    date.flag= 'end'
                    date.obj= obj
                    date.selectedDateTime = obj.enddate? new Date(obj.enddate):new Date()

                }
            }
        }

        FluTextBox {
            id: searchInput
            placeholderText: "请输入搜索内容"
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width *0.7
            width: 180
            height: parent.height
            font.pixelSize: 14
        }
        FluButton {
            text: "🔍 查询"
            width: 60
            height: parent.height
            font.pixelSize: height*0.5
            onClicked: {
                backend.to_search(search,searchInput.text)
            }
        }
        FluButton {
            text: "📄 导出"
            width: 60
            height:  parent.height
            font.pixelSize: height*0.5
            normalColor:'green'
            hoverColor:'lightgreen'
            textColor:'white'
            onClicked: {
            }
        }
    }
}
