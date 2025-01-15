import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import PyCVQML 1.0 as Pycv



Window {
    id:windows
    width: 640
    height: 480
    visible: true
    title:qsTr(backend.title_name)
    FluInfoBar{
        id:infoBar
        root: windows
    }
    //导航条
    HeadMenu{
        id:head
        width:320
        height:40
    }
    Rectangle {
        width:320
        height:40
        anchors.top:head.bottom
    Rectangle {
        id: homePage
        anchors.fill: parent
        visible: backend.select_val == 1
        color: "lightgray"
        Text {
            text: "这是首页内容"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: systemConfigPage
        anchors.fill: parent
        visible: backend.select_val==2
        color: "lightblue"
        Text {
            text: "这是系统配置页面内容"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: dataQueryPage
        anchors.fill: parent
        visible: backend.select_val==3
        color: "lightyellow"
        Text {
            text: "这是数据查询页面内容"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: chartPage
        anchors.fill: parent
        visible: backend.select_val == 4
        color: "lightgreen"
        Text {
            text: "这是图表页面内容"
            anchors.centerIn: parent
        }
    }

    }
// 视频
    Rectangle{
        id:video_img
        color:"transparent"
        anchors.centerIn:parent
        width:450
        height:300
        Pycv.CVQImage{
            anchors.fill:parent
            image:backend.image

        }
    }

    FluButton {
        id: myButton
        text: "Click Me"
        anchors.top: video_img.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            backend.on_button_clicked()
        }

    }
 Rectangle{
        anchors.centerIn:parent
        width:200
        height:150
        FluChart{
            anchors.fill: parent
            chartType: "doughnut"
            chartData: { return {
                    labels: [
                        'Red',
                        'Blue',
                        'Yellow'
                    ],
                    datasets: [{
                            label: 'My First Dataset',
                            data: [300, 50, 100],
                            backgroundColor: [
                                'rgb(255, 99, 132)',
                                'rgb(54, 162, 235)',
                                'rgb(255, 205, 86)'
                            ],
                            hoverOffset: 4
                        }]
                }
            }
            chartOptions: { return {
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Chart.js Doughnut Chart - Stacked'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false
                    }
                }
            }
        }
    }
}
