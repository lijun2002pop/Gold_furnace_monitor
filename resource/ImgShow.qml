import QtQuick
import QtQuick.Controls
import FluentUI

Window {
    id: windows
    width: 600
    height: 500
    visible: true
    title: "图片详情"
    property string imgpath: '1.jpg'
    Item{
        id: imagediv
        width:parent.width
        height:parent.height
        anchors.centerIn: parent
        Text{
            text:'图片加载失败'
            font.pixelSize:parent.height*0.1
            anchors.centerIn: parent
        }
        Image {
            id: popupImage
            fillMode:Image.Stretch
            width:parent.width
            height:parent.height
            anchors.centerIn: parent
            source: "../"+imgpath
        }
    }
}
