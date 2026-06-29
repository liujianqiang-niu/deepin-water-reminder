import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height
    property bool flashing: false

    // 乌云层
    Rectangle { width: sw; height: sh * 0.4; y: -sh * 0.05
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#080810" }
            GradientStop { position: 0.2; color: "#0f0f22" }
            GradientStop { position: 0.5; color: "#1a1a33" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.6
    }
    Rectangle { width: sw * 0.7; height: sh * 0.15; x: sw * 0.1; y: sh * 0.02
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0c0c1a" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.5
        SequentialAnimation on x { loops: Animation.Infinite
            NumberAnimation { from: sw * 0.1; to: sw * 0.15; duration: 10000; easing.type: Easing.InOutSine }
            NumberAnimation { from: sw * 0.15; to: sw * 0.1; duration: 10000; easing.type: Easing.InOutSine }
        }
    }
    Rectangle { width: sw * 0.5; height: sh * 0.12; x: sw * 0.35; y: sh * 0.05
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0a0a18" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.4
        SequentialAnimation on x { loops: Animation.Infinite
            NumberAnimation { from: sw * 0.35; to: sw * 0.30; duration: 12000; easing.type: Easing.InOutSine }
            NumberAnimation { from: sw * 0.30; to: sw * 0.35; duration: 12000; easing.type: Easing.InOutSine }
        }
    }

    // 闪电闪光
    Rectangle { anchors.fill: parent
        color: flashing ? "#eeeeff" : "#ffffff"
        opacity: flashing ? 0.4 : 0
        Behavior on opacity { NumberAnimation { duration: 50 } }
    }
    Rectangle { width: sw; height: sh * 0.3; anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aabbff" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: flashing ? 0.2 : 0
        Behavior on opacity { NumberAnimation { duration: 80 } }
    }
    Timer { id: lt; interval: 2200; running: true; repeat: true
        onTriggered: {
            flashing = true
            if (typeof overlayWindow !== "undefined" && overlayWindow.shake) overlayWindow.shake(10)
        }
        onIntervalChanged: { interval = 1800 + Math.random() * 3500 }
    }
    Timer { id: fr; interval: 150; running: false; repeat: false
        onTriggered: { flashing = false }
    }
    onFlashingChanged: { if (flashing) fr.start() }

    // 远雨层
    Repeater { model: 80
        Rectangle { id: farDrop; property real frx: Math.random() * sw
            property real fsp: 300 + Math.random() * 400
            x: frx; y: -20; width: 0.6; height: 8 + Math.random() * 10
            color: "#8899bb"; rotation: 12; opacity: 0.06 + Math.random() * 0.08
            SequentialAnimation { running: true; loops: Animation.Infinite
                ParallelAnimation {
                    NumberAnimation { target: farDrop; property: "y"; from: -20; to: sh + 20; duration: fsp; easing.type: Easing.Linear }
                    NumberAnimation { target: farDrop; property: "x"; from: frx; to: frx + 30 + Math.random() * 20; duration: fsp; easing.type: Easing.Linear }
                }
            }
        }
    }

    // 主雨滴
    Repeater { model: 90
        Rectangle { id: drop; property real rx: Math.random() * sw
            property real sp: 180 + Math.random() * 350
            property real thick: Math.random() > 0.65 ? 2.2 : 1.0
            x: rx; y: -30; width: thick; height: 14 + Math.random() * 22
            color: "#aabbdd"; rotation: 10 + Math.random() * 5; opacity: 0.2 + Math.random() * 0.25
            SequentialAnimation { running: true; loops: Animation.Infinite
                ParallelAnimation {
                    NumberAnimation { target: drop; property: "y"; from: -30; to: sh + 30; duration: sp; easing.type: Easing.Linear }
                    NumberAnimation { target: drop; property: "x"; from: rx; to: rx + 50 + Math.random() * 40; duration: sp; easing.type: Easing.Linear }
                }
            }
        }
    }

    // 落地溅射
    Repeater { model: 15
        Item { id: splash; property real spx: Math.random() * sw
            property real spy: sh * 0.92
            width: 20; height: 15; x: spx; y: spy; opacity: 0
            Rectangle { width: 3; height: 8; x: 8; y: 0; color: "#99aacc"; radius: 1.5; rotation: -20 }
            Rectangle { width: 3; height: 6; x: 5; y: 2; color: "#99aacc"; radius: 1.5; rotation: -40 }
            Rectangle { width: 3; height: 7; x: 12; y: 1; color: "#99aacc"; radius: 1.5; rotation: 15 }
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: 500 + Math.random() * 2000 }
                SequentialAnimation {
                    NumberAnimation { target: splash; property: "opacity"; from: 0; to: 0.4; duration: 30 }
                    NumberAnimation { target: splash; property: "opacity"; from: 0.4; to: 0; duration: 200 }
                }
            }
        }
    }

    // 水面反光
    Rectangle { width: sw; height: sh * 0.04; anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#334466" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.2
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.15; to: 0.28; duration: 1500; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.28; to: 0.15; duration: 1500; easing.type: Easing.InOutSine }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter; y: sh * 0.5
        text: "风雨无阻，记得喝水"; font.pixelSize: Math.max(30, sh * 0.09); font.bold: true
        color: "#ffffff"; style: Text.Outline; styleColor: "#222233"
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.6; to: 1.0; duration: 1000 }
            NumberAnimation { from: 1.0; to: 0.6; duration: 1000 }
        }
    }
}
