import QtQuick
import QtQuick.Window
import QtQuick.Controls
import FluentUI

Rectangle{
    id:grid
    width: parent.width
    height:parent.height
    anchors.top: parent.top
color:'blue'
    Image{
        id:logo
        width:parent.width*0.4
        height:parent.height*0.8
        smooth:true
        anchors.left:parent.left
        anchors.leftMargin:parent.width*0.02
        anchors.top:parent.top
        anchors.topMargin:parent.height*0.35
        source:"../Source/logo.png"
    }

        // 首页按钮
        FluButton {
            id: homeButton
            text: "首页"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: logo.right
            onClicked: backend.select_val = 1
        }

        // 系统配置按钮
        FluButton {
            id: systemConfigButton
            text: "系统配置"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: homeButton.right
            onClicked: backend.select_val = 2
        }

        // 数据查询按钮
        FluButton {
            id: dataQueryButton
            text: "数据查询"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: systemConfigButton.right
            onClicked:backend.select_val = 3
        }

        // 图表按钮
        FluButton {
            id: chartButton
            text: "图表"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: dataQueryButton.right
            onClicked: {backend.select_val = 4
        }

        }

}