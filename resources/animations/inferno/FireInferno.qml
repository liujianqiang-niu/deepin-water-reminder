import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height

    // 火焰底部光晕
    Rectangle { id: fireGlow
        width: sw * 1.1; height: sh * 0.5
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ff8800" }
            GradientStop { position: 0.15; color: "#ff5500" }
            GradientStop { position: 0.35; color: "#cc2200" }
            GradientStop { position: 0.6; color: "#661100" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.55
        SequentialAnimation on opacity { running: true; loops: Animation.Infinite
            NumberAnimation { from: 0.45; to: 0.60; duration: 700; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.60; to: 0.45; duration: 700; easing.type: Easing.InOutSine }
        }
    }

    // 热浪叠加
    Rectangle { anchors.fill: parent; color: "#ff4400"; opacity: 0
        SequentialAnimation on opacity { running: true; loops: Animation.Infinite
            NumberAnimation { from: 0; to: 0.04; duration: 1000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.04; to: 0; duration: 1000; easing.type: Easing.InOutSine }
        }
    }

    // 大火焰舌
    Repeater { model: 25
        Rectangle { id: bigFlame
            property real bx: sw * 0.1 + Math.random() * sw * 0.8
            property real rt: 1200 + Math.random() * 2000
            property real sa: 30 + Math.random() * 60
            property real fw: 20 + Math.random() * 30
            property real fh: fw * (2.5 + Math.random() * 4)
            width: fw; height: fh; radius: fw / 2; x: bx; y: sh; opacity: 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ffee44" }
                GradientStop { position: 0.2; color: "#ffaa00" }
                GradientStop { position: 0.5; color: "#ff4400" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 1500 }
                ParallelAnimation {
                    NumberAnimation { target: bigFlame; property: "y"; to: sh * 0.05; duration: rt; easing.type: Easing.OutQuad }
                    SequentialAnimation {
                        NumberAnimation { target: bigFlame; property: "x"; from: bx; to: bx + sa; duration: rt * 0.4; easing.type: Easing.InOutSine }
                        NumberAnimation { target: bigFlame; property: "x"; from: bx + sa; to: bx - sa * 0.3; duration: rt * 0.6; easing.type: Easing.InOutSine }
                    }
                    SequentialAnimation {
                        NumberAnimation { target: bigFlame; property: "scale"; from: 0.8; to: 1.1; duration: rt * 0.3 }
                        NumberAnimation { target: bigFlame; property: "scale"; from: 1.1; to: 0.6; duration: rt * 0.7 }
                    }
                }
                SequentialAnimation {
                    NumberAnimation { target: bigFlame; property: "opacity"; from: 0; to: 0.7; duration: rt * 0.05 }
                    NumberAnimation { target: bigFlame; property: "opacity"; from: 0.7; to: 0; duration: rt * 0.95 }
                }
            }
        }
    }

    // 小火星
    Repeater { model: 40
        Rectangle { id: spark
            property real sx: Math.random() * sw
            property real sparkR: 2 + Math.random() * 4
            width: sparkR; height: sparkR; radius: sparkR / 2; x: sx; y: sh; opacity: 0
            color: Math.random() > 0.5 ? "#ffdd00" : "#ff8800"
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 2500 }
                ParallelAnimation {
                    NumberAnimation { target: spark; property: "y"; from: sh * 0.85; to: -20; duration: 1500 + Math.random() * 2000; easing.type: Easing.OutQuad }
                    NumberAnimation { target: spark; property: "x"; from: sx; to: sx + (Math.random() - 0.5) * 120; duration: 1500 + Math.random() * 2000; easing.type: Easing.InOutSine }
                }
                SequentialAnimation {
                    NumberAnimation { target: spark; property: "opacity"; from: 0; to: 1; duration: 100 }
                    NumberAnimation { target: spark; property: "opacity"; from: 1; to: 0.8; duration: 500 }
                    NumberAnimation { target: spark; property: "opacity"; from: 0.8; to: 0; duration: 1000 + Math.random() * 1000 }
                }
            }
        }
    }

    // 余烬
    Repeater { model: 20
        Rectangle { id: ember
            property real ex: Math.random() * sw
            property real er: 3 + Math.random() * 5
            width: er; height: er; radius: er / 2; x: ex; y: sh * 0.2; opacity: 0
            color: Math.random() > 0.4 ? "#ff6600" : "#ffaa00"
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 4000 }
                ParallelAnimation {
                    NumberAnimation { target: ember; property: "y"; from: sh * 0.4; to: -30; duration: 3000 + Math.random() * 3000; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ember; property: "x"; from: ex; to: ex + (Math.random() - 0.5) * 100; duration: 3000 + Math.random() * 3000; easing.type: Easing.InOutSine }
                }
                SequentialAnimation {
                    NumberAnimation { target: ember; property: "opacity"; from: 0; to: 0.9; duration: 200 }
                    NumberAnimation { target: ember; property: "opacity"; from: 0.9; to: 0.5; duration: 1500 }
                    NumberAnimation { target: ember; property: "opacity"; from: 0.5; to: 0; duration: 1500 + Math.random() * 1500 }
                }
            }
        }
    }

    // 火焰中心强光
    Rectangle { width: sw * 0.3; height: sh * 0.2
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ffffff" }
            GradientStop { position: 0.15; color: "#ffee88" }
            GradientStop { position: 0.5; color: "#ff8800" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.2
        SequentialAnimation on opacity { running: true; loops: Animation.Infinite
            NumberAnimation { from: 0.15; to: 0.28; duration: 600; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.28; to: 0.15; duration: 600; easing.type: Easing.InOutSine }
        }
    }
}
