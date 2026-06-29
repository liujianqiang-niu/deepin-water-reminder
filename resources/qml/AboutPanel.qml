import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: aboutWindow
    width: 400
    height: 280
    title: qsTr("关于 - 喝水提醒")
    flags: Qt.WindowCloseButtonHint | Qt.WindowTitleHint
    color: palette.window

    contentItem.implicitHeight: 260

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        Label {
            text: qsTr("Deepin Water")
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: qsTr("桌面喝水提醒助手")
            font.pixelSize: 14
            color: palette.midlight
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle { height: 1; Layout.preferredWidth: 200; color: palette.mid; Layout.alignment: Qt.AlignHCenter }

        Label {
            text: qsTr("版本：") + (typeof appVersion !== "undefined" ? appVersion : "1.0.0")
            font.pixelSize: 13
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: qsTr("技术栈：Qt 6 + QML + C++17")
            font.pixelSize: 13
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: qsTr("许可证：GPL-3.0-or-later")
            font.pixelSize: 13
            Layout.alignment: Qt.AlignHCenter
        }

        Item { Layout.preferredHeight: 16 }

        Button {
            text: qsTr("关闭")
            Layout.alignment: Qt.AlignHCenter
            onClicked: aboutWindow.close()
        }
    }
}
