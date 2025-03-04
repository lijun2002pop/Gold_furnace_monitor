import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

Rectangle {
    id: grid
    property var obj: backend.pagechart
    property var warnlist: obj.warn_data
    property var errlist: obj.err_data
    width: parent.width
    height: parent.height
    color: 'lightgray'
    RowLayout {
        anchors.margins: parent.height *0.05
        anchors.fill: parent
        spacing:parent.width *0.01
        Rectangle {
            color: "transparent"
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width *0.45
            Image {
                    anchors.fill: parent
                    smooth: true
                    source: "../Source/grid.png"
                }
            FluChart{
                id:chart1
                anchors.margins: parent.height *0.05
                anchors.fill: parent
                chartType: "doughnut"
                chartData: { return {
                        labels: [
                            '记录次数（次） '+ warnlist[0],
                            '一般报警（次） '+warnlist[1],
                            '严重报警（次） '+warnlist[2],
                        ],
                        datasets: [{
                                data: [500, 10, 5],
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
                        cutoutPercentage: 50, // 设置空心大小为50%，你可以根据需要调整这个值
                        maintainAspectRatio: false,
                        title: {
                            display: true,
                            text: '累计报警统计',
                            fontSize: 24,  // 调整字体大小，这里设置为24，你可以根据需要调整
                            fontColor: '#FF53FFFF'  // 设置字体颜色为绿色
                        },
                        tooltips: {
                            mode: 'index',
                            intersect: false,
                            callbacks: {
                                label: function(tooltipItem, data) {
                                    return data.labels[tooltipItem.index]
                                }
                            }
                        },
                        legend: {
                            display: true,
                            position: 'right', // 将图例放置在右侧
                            labels: {
                                // 设置图例标签的字体大小
                                fontSize: 18, // 您可以根据需要调整这个值
                                // 如果需要，还可以设置其他样式，如字体颜色
                                fontColor: '#333333' // 深灰色，例如
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            color: "transparent"
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width *0.45
            Image {
                    anchors.fill: parent
                    smooth: true
                    source: "../Source/grid.png"
                }
            FluChart{
                id:chart2
                anchors.margins: parent.height *0.05
                anchors.fill: parent
                chartType: "bar"
                chartData: { return {
                        labels: [
                            '网络异常',
                            '温度趋势异常',
                            '其他异常'
                        ],
                        datasets: [
                        {
                            barPercentage:0.5,
                            label: '网络异常 '+errlist[0],
                            data: [errlist[0], 0, 0],
                            backgroundColor: 'red',
                            stack: 'exceptions' // 使用相同的堆叠标签来将所有数据集堆叠在一起
                        },
                        {
                            barPercentage:0.5,
                            label: '温度趋势异常 '+errlist[1],
                            data: [0, errlist[1], 0], // 只有第二个数据点有效，其余为0
                            backgroundColor: 'yellow',
                            stack: 'exceptions'
                        },
                        {
                            barPercentage:0.5,
                            label: '其他异常 '+errlist[2],
                            data: [0, 0, errlist[2]], // 只有第三个数据点有效，其余为0
                            backgroundColor: 'pink',
                            stack: 'exceptions'
                        }
                    ]
                    }
                }
                chartOptions: { return {
                       responsive: true,
                        maintainAspectRatio: false,
                        title: {
                            display: true,
                            text: '累计异常统计',
                            fontSize: 24,
                            fontColor: '#FF53FFFF'
                        },
                        tooltips: {
                            mode: 'index',
                            intersect: false,
                            callbacks: {
                                label: function(tooltipItem, data) {
                                return data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
                                },
                            }
                        },
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                padding:30,
                                // 设置图例标签的字体大小
                                fontSize: 18, // 您可以根据需要调整这个值
                                // 如果需要，还可以设置其他样式，如字体颜色
                                fontColor: '#333333' // 深灰色，例如
                            }
                        },
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        obj.pagechartChanged.connect(function() {
             chart1.height+=1
             chart2.height+=1
             chart1.height-=1
             chart2.height-=1
        })
    }
}