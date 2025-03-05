import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

Rectangle {
    property var obj: backend.linechart
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
            id:chartContainer
            color: "lightblue"
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height *0.95
            FluChart{
            id:linechart
            anchors.fill: parent
            chartType: "line"
            chartData: { return {
                    labels: obj.xdata,
                    datasets: [{
                                label: '温度',
                                data: obj.ydata,
                                fill: true,
                                borderColor: 'rgb(70, 190, 255)',
                                pointBackgroundColor:'green',
                                pointRadius:5,
                                tension: 0.1
                            }]
                }
            }
            chartOptions: { return {

                        maintainAspectRatio: false,
                        title: {
                            display: true,
                            text: '温度随时间变化图'
                        },
                        tooltips: {
                            mode: 'index',
                            intersect: true
                        }
                    }
                }
                Component.onCompleted: {
                    obj.linechartChanged.connect(function() {
                         linechart.height+=1
                         linechart.height-=1
                    })
                }
            }
        }
    }
}