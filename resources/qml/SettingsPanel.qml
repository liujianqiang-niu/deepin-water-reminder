import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: settingsWindow
    width: 460; height: 420
    title: qsTr("Deepin Water - 设置")
    flags: Qt.WindowCloseButtonHint | Qt.WindowTitleHint
    color: palette.window

    property var s: bridge ? bridge.settings : ({})
    property var themes: bridge ? bridge.availableThemes : []

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 20; spacing: 12

        Label { text: qsTr("提醒设置"); font.pixelSize: 20; font.bold: true; Layout.alignment: Qt.AlignHCenter }

        RowLayout {
            Label { text: qsTr("提醒间隔"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            ComboBox {
                id: intervalCb
                model: s.availableIntervals || ["15","30","45","60","90","120"]
                currentIndex: { var i = model.indexOf(String(s.intervalMinutes||60)); return i>=0 ? i : 3 }
                Layout.fillWidth: true
            }
            Label { text: qsTr("分钟"); font.pixelSize: 14 }
        }

        RowLayout {
            Label { text: qsTr("动画主题"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            ComboBox {
                id: themeCb
                model: themes.length>0 ? themes : ["ocean","galaxy","aurora","storm","inferno"]
                currentIndex: { var i = model.indexOf(s.animationTheme||"ocean"); return i>=0 ? i : 0 }
                Layout.fillWidth: true
            }
            Button { text: qsTr("预览"); onClicked: { bridge.setTheme(themeCb.currentText); bridge.playAnimation() } }
        }

        RowLayout {
            Label { text: qsTr("展示时长"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            ComboBox {
                id: durCb; model: ["3","5","8","10","15","20"]
                currentIndex: { var i = model.indexOf(String(s.animationDuration||8)); return i>=0 ? i : 2 }
                Layout.fillWidth: true
            }
            Label { text: qsTr("秒后关闭"); font.pixelSize: 14 }
        }

        Rectangle { height:1; Layout.fillWidth:true; color:palette.mid }

        CheckBox { id:autoCb; text:qsTr("开机自启"); checked:s.autoStart||false }

        Item { Layout.fillHeight:true }

        RowLayout {
            Layout.alignment: Qt.AlignRight; spacing:10
            Button { text:qsTr("取消"); onClicked:settingsWindow.close() }
            Button { text:qsTr("保存"); highlighted:true
                onClicked: {
                    bridge.saveSettings({
                        intervalMinutes: parseInt(intervalCb.currentText),
                        animationTheme: themeCb.currentText,
                        animationDuration: parseInt(durCb.currentText),
                        autoStart: autoCb.checked
                    })
                    settingsWindow.close()
                }
            }
        }
    }
}
