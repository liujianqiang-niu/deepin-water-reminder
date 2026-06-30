import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height

    // 背景：淡青 → 深绿渐变
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#a8d8a8" }
            GradientStop { position: 0.5; color: "#5a8a5a" }
            GradientStop { position: 1.0; color: "#2d5a2d" }
        }
    }

    // 远景雾气
    Rectangle {
        width: sw; height: sh * 0.5; anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#1a3a1a" }
        }
        opacity: 0.3
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.25; to: 0.35; duration: 6000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.35; to: 0.25; duration: 6000; easing.type: Easing.InOutSine }
        }
    }

    // 竹竿
    Repeater { model: 4
            Rectangle { id: stalk
                property real baseX: sw * (0.12 + index * 0.25)
                width: sw * 0.022; height: sh
                x: baseX; y: 0
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#8a6a3a" }
                    GradientStop { position: 0.5; color: "#6a4a2a" }
                    GradientStop { position: 1.0; color: "#4a3a1a" }
                }
                opacity: 0.75 + index * 0.05
                SequentialAnimation on x { loops: Animation.Infinite
                    NumberAnimation { from: baseX; to: baseX + 6; duration: 5000 + index * 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: baseX + 6; to: baseX - 4; duration: 5000 + index * 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: baseX - 4; to: baseX; duration: 5000 + index * 1000; easing.type: Easing.InOutSine }
                }
                // 竹节
                Repeater { model: 8
                    Rectangle {
                        property real segY: (index + 1) * (sh / 9)
                        width: parent.width + sw * 0.004; height: sh * 0.006
                        x: -sw * 0.002; y: segY
                        color: "#3a2a1a"; radius: 2
                    }
                }
            }
        }

    // 竹叶
    Repeater { model: 18
        Rectangle {
            property real lx: sw * (0.1 + Math.random() * 0.8)
            property real ly: sh * (0.15 + Math.random() * 0.5)
            width: sw * 0.03; height: sw * 0.012
            x: lx; y: ly
            radius: height / 2
            color: "#3a7a3a"
            opacity: 0.5 + Math.random() * 0.3
            transformOrigin: Item.Left
            rotation: Math.random() * 360
            SequentialAnimation on rotation { loops: Animation.Infinite
                NumberAnimation { from: rotation; to: rotation + 12; duration: 4000 + Math.random() * 3000; easing.type: Easing.InOutSine }
                NumberAnimation { from: rotation + 12; to: rotation - 8; duration: 4000 + Math.random() * 3000; easing.type: Easing.InOutSine }
                NumberAnimation { from: rotation - 8; to: rotation; duration: 4000 + Math.random() * 3000; easing.type: Easing.InOutSine }
            }
        }
    }

    // 雨丝
    Repeater { model: 120
        Rectangle {
            id: raindrop
            property real rx: Math.random() * sw
            property real ry: -Math.random() * sh
            property real len: 18 + Math.random() * 28
            property real dur: 600 + Math.random() * 700
            width: 1.5; height: len
            x: rx; y: ry
            color: "#cceecc"
            opacity: 0.25 + Math.random() * 0.25
            rotation: 12
            SequentialAnimation { running: true; loops: Animation.Infinite
                ParallelAnimation {
                    NumberAnimation { target: raindrop; property: "y"; from: -len; to: sh; duration: dur; easing.type: Easing.Linear }
                    NumberAnimation { target: raindrop; property: "x"; from: rx; to: rx + len * 0.21; duration: dur; easing.type: Easing.Linear }
                }
                PauseAnimation { duration: Math.random() * 1500 }
            }
        }
    }

    // 雨滴落地涟漪
    Repeater { model: 30
        Rectangle {
            id: ripple
            property real rpx: Math.random() * sw
            property real rpy: sh * (0.85 + Math.random() * 0.12)
            property real rdur: 1200 + Math.random() * 800
            property real maxSize: 8 + Math.random() * 16
            width: 4; height: 4; radius: 2
            x: rpx; y: rpy
            color: "transparent"
            border.color: "#aaccaa"; border.width: 1
            opacity: 0
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 3000 }
                ParallelAnimation {
                    NumberAnimation { target: ripple; property: "width"; from: 4; to: maxSize; duration: rdur; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ripple; property: "height"; from: 4; to: maxSize; duration: rdur; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ripple; property: "opacity"; from: 0.6; to: 0; duration: rdur; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    // 地面湿润
    Rectangle { width: sw; height: sh * 0.06; anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#1a3a1a" }
        }
        opacity: 0.4
    }
}
