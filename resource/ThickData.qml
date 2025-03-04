import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

Rectangle {
    property var obj: backend.thick
    property string search: obj.flag
    id: grid
    width: parent.width
    height: parent.height
    color: 'transparent'
    ColumnLayout {
        anchors.margins: parent.height *0.05
        anchors.fill: parent
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height *0.05
            TableSearch{
            }
        }
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height *0.9
            ThickTable {
                tabledata:obj.data
            }
        }
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height *0.1
            PageNation{
            }
        }
    }
}