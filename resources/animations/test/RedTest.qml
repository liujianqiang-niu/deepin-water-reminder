import QtQuick

Rectangle {
    color: "#ff0000"
    anchors.fill: parent

    Rectangle {
        anchors.centerIn: parent
        width: 300; height: 200
        color: "#ffffff"
        radius: 20

        Text {
            anchors.centerIn: parent
            text: "✅ 动画机制正常！"
            font.pixelSize: 32
            font.bold: true
            color: "#000000"
        }
    }

    Component.onCompleted: {
        console.log("[TestAnim] Loaded — if you see a red screen, overlay works")
    }
}
