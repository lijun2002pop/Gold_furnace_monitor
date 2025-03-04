import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

RowLayout{
    property int page: obj.page
    property int count: obj.length
    property int total: 10
    height:parent.height
    anchors.right: parent.right
    anchors.rightMargin:parent.height*0.2
    anchors.verticalCenter : parent.verticalCenter        // 垂直居中
    Component.onCompleted: {
        obj.PageChanged.connect(function() {
             pagination.pageCurrent = obj.page
        })
    }
    FluPagination{
        id:pagination
        anchors.right: ptext.left
        Layout.preferredHeight: parent.height*0.6
        pageCurrent: page
        itemCount: count
        __itemPerPage:total
        pageButtonCount: 5
        onRequestPage:(page,total)=> {
            backend.update_page(search,page,total)
        }
    }
    Label {
            id:ptext
            font.pixelSize:height* 0.8
            text: "共 " + count + " 条记录    到 "
        }
    FluTextBox {
        id:gopage
        width:parent.width*0.05
        height:parent.height *0.4
        placeholderText: "页码"
        color:"black"
        onCommit: {
            if(gopage.text){
                backend.update_page(search,gopage.text,total)
            }
        }
    }
    Label {
        font.pixelSize:height* 0.8
        text: "页"
    }
}