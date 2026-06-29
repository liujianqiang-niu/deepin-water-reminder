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
