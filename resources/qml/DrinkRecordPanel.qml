import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: recordWindow
    width: 420; height: 380
    title: qsTr("Deepin Water - 饮水记录")
    flags: Qt.WindowCloseButtonHint | Qt.WindowTitleHint
    color: palette.window

    Item {
        anchors.fill: parent; anchors.margins: 20

        Column {
            id: contentCol
            anchors.fill: parent
            spacing: 12

            Label { text: qsTr("饮水记录"); font.pixelSize:20; font.bold:true; width:parent.width; horizontalAlignment:Text.AlignHCenter }

            Row {
                width: parent.width; spacing:14
                Rectangle { width:(parent.width-14)/2; height:100; radius:12; color:"#e3f2fd"; border.color:"#90caf9"
                    ColumnLayout { anchors.centerIn:parent
                        Label { text:qsTr("今日"); font.pixelSize:13; color:"#1565c0"; Layout.alignment:Qt.AlignHCenter }
                        Text { text:bridge?String(bridge.todayDrinkCount):"0"; font.pixelSize:36; font.bold:true; color:"#0d47a1"; Layout.alignment:Qt.AlignHCenter }
                        Label { text:qsTr("杯"); font.pixelSize:12; color:"#1565c0"; Layout.alignment:Qt.AlignHCenter }
                    }
                }
                Rectangle { width:(parent.width-14)/2; height:100; radius:12; color:"#e8f5e9"; border.color:"#a5d6a7"
                    ColumnLayout { anchors.centerIn:parent
                        Label { text:qsTr("本周"); font.pixelSize:13; color:"#2e7d32"; Layout.alignment:Qt.AlignHCenter }
                        Text { text:bridge?String(bridge.weekDrinkCount):"0"; font.pixelSize:36; font.bold:true; color:"#1b5e20"; Layout.alignment:Qt.AlignHCenter }
                        Label { text:qsTr("杯"); font.pixelSize:12; color:"#2e7d32"; Layout.alignment:Qt.AlignHCenter }
                    }
                }
            }

            Rectangle {
                id: progressCard
                width: parent.width; height: 44; radius: 8
                color: "#f5f5f5"; border.color: "#bdbdbd"; border.width: 1
                property int todayCount: bridge ? bridge.todayDrinkCount : 0
                property int goal: (bridge && bridge.settings && bridge.settings.dailyGoal) ? bridge.settings.dailyGoal : 8
                property real ratio: goal > 0 ? Math.min(1.0, todayCount / goal) : 0

                Rectangle {
                    anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                    width: parent.width * parent.ratio
                    color: parent.ratio >= 1.0 ? "#4caf50" : "#29b6f6"
                    radius: 8
                    Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
                }
                Text {
                    anchors.centerIn: parent
                    text: qsTr("今日 %1/%2 杯").arg(progressCard.todayCount).arg(progressCard.goal)
                    color: "#333333"; font.pixelSize: 14; font.bold: true
                }
            }

            Button { text:qsTr("记录一次喝水"); width:parent.width; highlighted:true
                onClicked: { if(bridge) bridge.recordDrink() }
            }
            Button { text:qsTr("重置记录"); width:parent.width
                onClicked: { if(bridge) bridge.clearDrinkHistory() }
            }
            Button { text:qsTr("关闭"); width:parent.width; onClicked:recordWindow.close() }
        }
    }
}
