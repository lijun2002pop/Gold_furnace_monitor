import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import PyCVQML 1.0 as Pycv

Window {
    id: grid
    visible: true
    width: 1280
    height: 700
    title: "区域快速绘制"
    onRectanglesChanged: {
        canvas.requestPaint(); // 当矩形列表变化时，重新绘制画布
    }

    // 存储矩形的列表
    property var rectangles: []
    property int startX: 0
    property int startY: 0
    property bool isDrawing: false
    property var currentRect: null // 当前正在绘制的矩形

    Item {
        id: drawingArea
        anchors.fill: parent

        // 显示图像
        Pycv.CVQImage {
            id: img
            width: 960
            height: 640
            anchors.margins: 0
            image: backend.camera.image
        }

        // 使用 Canvas 绘制矩形
        Canvas {
            id: canvas
            anchors.fill: parent
            renderTarget: Canvas.Image

            onPaint: {
                var ctx = canvas.getContext("2d");
                ctx.clearRect(0, 0, canvas.width, canvas.height); // 清除画布

                // 绘制所有矩形
                for (var i = 0; i < rectangles.length; ++i) {
                    var rect = rectangles[i];
                    ctx.fillStyle = "rgba(255, 0, 0, 0.3)"; // 半透明红色
                    ctx.strokeStyle = "black"; // 边框颜色
                    ctx.fillRect(rect.x, rect.y, rect.width, rect.height);
                    ctx.strokeRect(rect.x, rect.y, rect.width, rect.height);
                }

                // 绘制当前正在绘制的矩形
                if (isDrawing && currentRect) {
                    ctx.fillStyle = "rgba(0, 255, 0, 0.3)"; // 半透明绿色
                    ctx.strokeStyle = "black";
                    ctx.fillRect(currentRect.x, currentRect.y, currentRect.width, currentRect.height);
                    ctx.strokeRect(currentRect.x, currentRect.y, currentRect.width, currentRect.height);
                }
            }

            Component.onCompleted: {
                canvas.width = drawingArea.width;
                canvas.height = drawingArea.height;
                canvas.requestPaint(); // 初始化时绘制
            }
        }

        // 鼠标区域，用于绘制矩形
        MouseArea {
            anchors.fill: img
            onPressed: {
                isDrawing = true;
                startX = mouse.x;
                startY = mouse.y;
                currentRect = { x: startX, y: startY, width: 0, height: 0 }; // 初始化当前矩形
                toolTip.visible = true; // 显示提示
                toolTip.text = "正在绘制矩形...";
            }

            onPositionChanged: {
                if (isDrawing) {
                    // 更新当前矩形的宽度和高度
                    currentRect.width = mouse.x - startX;
                    currentRect.height = mouse.y - startY;
                    canvas.requestPaint(); // 实时重新绘制
                }
            }

            onReleased: {
                isDrawing = false;
                var endX = mouse.x;
                var endY = mouse.y;

                // 创建新矩形
                var newRect = {
                    x: Math.round(Math.min(startX, endX)),
                    y: Math.round(Math.min(startY, endY)),
                    width: Math.round(Math.abs(startX - endX)),
                    height: Math.round(Math.abs(startY - endY))
                };

                // 检查矩形是否有效
                if (rectangles.length <10 && newRect.x >= 0 && newRect.y >= 0 &&
                    endX <= img.width && endY <= img.height &&
                    newRect.width > 10 && newRect.height > 10) {
                    var temp = rectangles.slice(); // 创建数组副本
                    temp.push(newRect); // 添加到矩形列表
                    rectangles =[]
                    rectangles = temp; // 强制触发属性变更
                }

                currentRect = null; // 清空当前矩形
                canvas.requestPaint(); // 重新绘制
                toolTip.visible = false; // 隐藏提示
            }

            // 提示信息
            ToolTip {
                id: toolTip
                visible: false
                text: "正在绘制矩形..."
                timeout: 2000 // 2秒后自动隐藏
            }
        }

        // 底部按钮栏
        RowLayout {
            anchors.top: img.bottom
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            FluButton {
                text: "清除矩形"
                onClicked: {
                    rectangles = []; // 清空矩形列表
                    canvas.requestPaint(); // 重新绘制
                }
            }
            FluButton {
                text: "保存"
                onClicked: {
                    backend.camera.save_draw(JSON.stringify(rectangles),d_val1.text,d_val2.text); // 保存矩形
                    grid.visible = false; // 关闭窗口
                }
            }
            FluButton {
                text: "取消"
                onClicked: {
                    grid.visible = false; // 关闭窗口
                }
            }
            Text {
                text: "注意:保存会清除原有区域设置，将重新生成矩形区域！！！"
                font.bold: true
                color:"red"
            }
        }

        // 右侧矩形列表
        Column {
            id: rectList
            anchors {
                top: parent.top
                left: img.right
                right: parent.right
                margins: 10
            }
            spacing: 10
            RowLayout {
                Text {
                    text: "一般报警下限：>="
                    color:"black"
                }
                FluTextBox {
                    id:d_val1
                    cleanEnabled:true
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width *0.4
                    text: "0"
                    color:"red"
                }
                Text {
                    text: "°C"
                    color:"black"
                }
            }
            RowLayout {
                Text {
                    text: "严重报警下限：>="
                    color:"black"
                }
                FluTextBox {
                    id:d_val2
                    cleanEnabled:true
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width *0.4
                    text: "0"
                    color:"red"
                }
                Text {
                    text: "°C"
                    color:"black"
                }
            }
            // 显示所有矩形
            Repeater {
                model: rectangles
                delegate: Row {
                    spacing: 10
                    FluButton {
                        text: "删除"
                        onClicked: {
                            var temp = rectangles.slice(); // 创建数组副本
                            temp.splice(index, 1); // 删除矩形
                            rectangles = temp; // 强制触发属性变更
                            canvas.requestPaint(); // 重新绘制
                        }
                    }
                    Text {
                        function getRectangleText() {
                            let startX = modelData.x;
                            let startY = modelData.y;
                            let endX = startX + modelData.width;
                            let endY = startY + modelData.height;
                            return (index + 1) + "#区域:(" + startX + "," + startY + ")-(" + endX + "," + endY + ")";
                        }
                        text: getRectangleText()
                        color: "black"
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}