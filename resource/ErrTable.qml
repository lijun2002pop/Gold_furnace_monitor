import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ColumnLayout {
    function getcolor(index) {
        if (index == 1) {
            return '#FFEBE724'
        }
        if(index == 3){
            return 'red'
        }
        return 'white'
    }
    property var widthsRatio: [0.1, 0.15, 0.2, 0.3, 0.25,]
    property var headers: ["序号", "异常类型", "相机IP", "异常信息记录","异常发生时间"]
    property var tabledata:[]
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
                    color: "#F109FFE9"
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
            width: parent.width - 10 // 调整 ListView 的宽度
            height: parent.height
            model: tabledata
            delegate: Rectangle {
                width: listView.width
                height: listView.height * 0.1
                color: index % 2 === 0 ?"#FF0E1532" : "#FF122246"
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
                                color:getcolor(index)
                                font.pixelSize: listView.height * 0.04
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