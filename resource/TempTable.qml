import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ColumnLayout {
    property var widthsRatio: [0.1, 0.2, 0.2, 0.1, 0.1, 0.1, 0.2]
    property var headers: ["序号", "相机IP", "名称", "监测区域", "监测温度", "图片", "记录时间"]
    property var tabledata: []
    anchors.fill: parent
    RowLayout {
        id: headerRow
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.01
        width: parent.width
        height: parent.height * 0.1
        spacing: 0

        Repeater {
            model: headers.length
            delegate: Rectangle {
                Layout.fillWidth: false
                Layout.preferredWidth: headerRow.width * widthsRatio[index]
                Layout.preferredHeight: headerRow.height
                color: "#033B73"

                Text {
                    text: headers[index]  // 使用 headers 列表中的元素
                    anchors.centerIn: parent
                    font.bold: true
                    color: "white"
                    font.pixelSize: headerRow.height * 0.35
                }
            }
        }
    }

    ScrollView {
        id: scrollView
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.rightMargin: 10 // 设置滚动条的右边距
        clip: true
        ListView {
            id: listView
            width: parent.width - 10
            height: parent.height
            model: tabledata
            delegate: Rectangle {
                width: listView.width
                height: listView.height * 0.1
                color: index % 2 === 0 ? "#F0F0F0" : "#E0E0E0"
                border.color: "black"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    spacing: 2

                    Repeater {
                        model: modelData
                        delegate: Rectangle {
                            Layout.fillWidth: false
                            Layout.preferredWidth: listView.width * widthsRatio[index]
                            Layout.preferredHeight: parent.height
                            color: "transparent"
                            border.color: "black"
                            border.width: 1
                            Text {
                                text: modelData  // 从当前行数据中获取对应列的数据
                                anchors.centerIn: parent
                                color:index==2?"green":"black"
                                font.pixelSize: listView.height * 0.05
                                style: modelData.endsWith(".jpg") ? Text.Underline : Text.Normal
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if ( modelData.endsWith(".jpg")){
                                            imgshow.visible=true
                                            imgshow.imgpath=modelData
                                        }
                                    }
                                    cursorShape: modelData.endsWith(".jpg") ? Qt.PointingHandCursor : Qt.ArrowCursor
                                }
                            }

                        }
                    }
                }
            }
        }
    }
}