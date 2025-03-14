import QtQuick
import QtQuick.Controls
import FluentUI

Window {
    id: windows
    width: 600
    height: 500
    visible: true
    title: "日期选择窗口"
    property var obj:  backend.temp
    property var flag: "start"
    property var selectedDateTime: new Date()
    function formatDateTime(date) {
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);
        var hours = ("0" + date.getHours()).slice(-2);
        var minutes = ("0" + date.getMinutes()).slice(-2);
        var seconds = ("0" + date.getSeconds()).slice(-2);
        return year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
    }
    function parseDateTime(input) {
        var dateParts = input.split(" ");
        var current = ""
        if (dateParts.length === 2) {
            var date = dateParts[0].split("-");
            var time = dateParts[1].split(":");
            if (date.length === 3 && time.length === 3) {
                var parsedDate = new Date(
                    date[0], // year
                    date[1] - 1, // month (0-based)
                    date[2], // day
                    time[0], // hours
                    time[1], // minutes
                    time[2]  // seconds
                );
                current = formatDateTime(parsedDate);
            }
        }
         if(flag=="start"){
            obj.startdate = current
        }else{
            obj.enddate = current
        }
        windows.visible = false
    }
    Rectangle {
        id: drawingArea
        anchors.fill: parent
        color: "#0099ff"
        FluTextBox {
            anchors.margins: 35
            id: searchInput
            cleanEnabled:false
            placeholderText: "请输入日期"
            width: parent.width
            height: 50
            font.pixelSize: 14
            text: formatDateTime(selectedDateTime)
            onCommit: {
                parseDateTime(searchInput.text);
            }
        }

        // Calendar Picker to select date
        FluCalendarPicker {
            anchors.top: searchInput.bottom
            id: date
            current: selectedDateTime
            onAccepted: {
                selectedDateTime = new Date(selectedDateTime.setFullYear(current.getFullYear(), current.getMonth(), current.getDate()))
            }
        }

        // Time Picker to select time
        FluTimePicker {
            width: 100
            id: time
            anchors.left: date.right
            anchors.top: searchInput.bottom
            hourFormat: FluTimePickerType.HH
            current: selectedDateTime
            onAccepted: {
                selectedDateTime = new Date(selectedDateTime.setHours(current.getHours(), current.getMinutes(), current.getSeconds()))
            }
        }
        FluButton{
            id:submit
            anchors.left: time.right
            anchors.top: searchInput.bottom
            height:time.height
            width:200
            text:"确认"
            onClicked: {
                parseDateTime(searchInput.text);
            }
        }
        FluButton{
            anchors.left: submit.right
            anchors.top: searchInput.bottom
            height:time.height
            width:200
            text:"清除"
            onClicked: {
                parseDateTime("");
            }
        }
    }
}
