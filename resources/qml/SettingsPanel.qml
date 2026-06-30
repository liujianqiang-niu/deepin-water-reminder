import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: settingsWindow
    width: 460; height: 560
    title: qsTr("Deepin Water - 设置")
    flags: Qt.WindowCloseButtonHint | Qt.WindowTitleHint
    color: palette.window

    property var s: bridge ? bridge.settings : ({})
    property var themeIds: bridge && bridge.availableThemes ? bridge.availableThemes : ["ocean","galaxy","aurora","storm","inferno","bamboo","cherry"]
    property var themeNames: bridge && bridge.availableThemeNames ? bridge.availableThemeNames : ["碧海潮生","星河璀璨","极光幻境","雷暴来袭","烈焰涅槃","竹林听雨","落樱缤纷"]

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
                model: themeNames
                currentIndex: { var i = themeIds.indexOf(s.animationTheme||"ocean"); return i>=0 ? i : 0 }
                Layout.fillWidth: true
            }
            Button { text: qsTr("预览"); onClicked: { bridge.setTheme(themeIds[themeCb.currentIndex]); bridge.playAnimation() } }
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

        RowLayout {
            Label { text: qsTr("目标杯数"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            ComboBox {
                id: goalCb; model: ["4","6","8","10","12"]
                currentIndex: { var i = model.indexOf(String(s.dailyGoal||8)); return i>=0 ? i : 2 }
                Layout.fillWidth: true
            }
            Label { text: qsTr("杯/天"); font.pixelSize: 14 }
        }

        RowLayout {
            Label { text: qsTr("提醒文案"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            TextField {
                id: msgField
                text: s.reminderMessage || ""
                placeholderText: qsTr("留空使用默认文案")
                Layout.fillWidth: true
            }
        }

        Rectangle { height:1; Layout.fillWidth:true; color:palette.mid }

        CheckBox { id:autoCb; text:qsTr("开机自启"); checked:s.autoStart||false }

        CheckBox { id:quoteCb; text:qsTr("显示趣味语录"); checked:s.showQuotes===true }

        CheckBox { id:soundCb; text:qsTr("开启提醒音效"); checked:s.soundEnabled===true }

        RowLayout {
            Label { text: qsTr("文字入场"); font.pixelSize: 14; Layout.preferredWidth: 90 }
            ComboBox {
                id: textAnimCb; model: [qsTr("四面八方"), qsTr("从下而上"), qsTr("缩放旋转")]
                currentIndex: { var v = s.textAnimationStyle||0; return (v>=0 && v<3) ? v : 0 }
                Layout.fillWidth: true
            }
        }

        Item { Layout.fillHeight:true }

        RowLayout {
            Layout.alignment: Qt.AlignRight; spacing:10
            Button { text:qsTr("取消"); onClicked:settingsWindow.close() }
            Button { text:qsTr("保存"); highlighted:true
                onClicked: {
                    bridge.saveSettings({
                        intervalMinutes: parseInt(intervalCb.currentText),
                        animationTheme: themeIds[themeCb.currentIndex],
                        animationDuration: parseInt(durCb.currentText),
                        autoStart: autoCb.checked,
                        showQuotes: quoteCb.checked,
                        dailyGoal: parseInt(goalCb.currentText),
                        reminderMessage: msgField.text,
                        soundEnabled: soundCb.checked,
                        textAnimationStyle: textAnimCb.currentIndex
                    })
                    settingsWindow.close()
                }
            }
        }
    }
}
