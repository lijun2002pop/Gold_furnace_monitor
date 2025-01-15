import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 2.12

// 定义Toast组件，用于显示信息提示
Item {
    id: toast
    property alias message: text.text  // 将内部Text组件的文本属性暴露出来，方便外部设置消息内容
    property int duration: 3000 // 默认显示3秒，可外部设置修改
    width: parent.width
    height: parent.height
    // 使用anchors将Toast组件定位在父容器的顶部中间位置
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.margins: 10  // 设置距离顶部的边距，可根据实际情况调整

    visible: false
    opacity: 0
    // 背景矩形，用于显示提示框的外观
    Rectangle {
        anchors.fill: parent
        color: "lightgray"
        radius: 10
    }
    // 文本组件，用于显示具体的提示消息
    Text {
        id: text
        anchors.centerIn: parent
        text: ""
    }
    SequentialAnimation {
                    id:ddd
                    NumberAnimation {
                        target: toast
                        property: "opacity"
                        to: 0
                        duration: 500
                    }
                    onStopped: {
                        toast.visible = false
                    }
                }
    Timer {
        id:sttt
            interval: duration
            repeat: false
            onTriggered: {
                ddd.start()
            }
        }
    // 显示提示的函数
    function show() {
        toast.visible = true
        toast.opacity = 1
        sttt.start()
    }
}