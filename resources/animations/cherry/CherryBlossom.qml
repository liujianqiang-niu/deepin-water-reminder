import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height

    // 背景：淡粉 + 淡蓝天空感
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ffd6e0" }
            GradientStop { position: 0.4; color: "#f0c4d8" }
            GradientStop { position: 0.7; color: "#d8d4f0" }
            GradientStop { position: 1.0; color: "#b8c8e8" }
        }
    }

    // 柔光氛围
    Rectangle {
        width: sw * 1.2; height: sh * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#fff0f5" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.5
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.4; to: 0.55; duration: 5000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.55; to: 0.4; duration: 5000; easing.type: Easing.InOutSine }
        }
    }

    // 远景花枝轮廓
    Repeater { model: 3
        Rectangle {
            property real bx: sw * (0.05 + index * 0.4)
            width: sw * 0.008; height: sh * 0.7
            x: bx; y: 0
            color: "#5a3a4a"
            opacity: 0.15
            rotation: index % 2 === 0 ? 5 : -5
            transformOrigin: Item.Top
        }
    }

    // 飘落花瓣
    Repeater { model: 80
        Rectangle {
            id: petal
            property real px: Math.random() * sw
            property real psize: 8 + Math.random() * 14
            property real pdur: 6000 + Math.random() * 6000
            property real psway: 40 + Math.random() * 80
            property real pstartRot: Math.random() * 360
            width: psize; height: psize * 0.7
            radius: psize * 0.35
            x: px; y: -psize
            color: Math.random() > 0.5 ? "#ffb3c8" : "#ff8aab"
            opacity: 0.55 + Math.random() * 0.35
            SequentialAnimation { running: true; loops: Animation.Infinite
                ParallelAnimation {
                    NumberAnimation { target: petal; property: "y"; from: -psize; to: sh + psize; duration: pdur; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: petal; property: "x"; from: px; to: px + psway; duration: pdur / 2; easing.type: Easing.InOutSine }
                    NumberAnimation { target: petal; property: "x"; from: px + psway; to: px - psway * 0.5; duration: pdur / 2; easing.type: Easing.InOutSine }
                    NumberAnimation { target: petal; property: "rotation"; from: pstartRot; to: pstartRot + 360; duration: pdur; easing.type: Easing.Linear }
                }
                PauseAnimation { duration: Math.random() * 2000 }
            }
        }
    }

    // 近景大花瓣
    Repeater { model: 15
        Rectangle {
            id: bigPetal
            property real px: Math.random() * sw
            property real psize: 18 + Math.random() * 16
            property real pdur: 5000 + Math.random() * 4000
            property real psway: 60 + Math.random() * 60
            width: psize; height: psize * 0.7
            radius: psize * 0.35
            x: px; y: -psize
            color: "#ff6b95"
            opacity: 0.4 + Math.random() * 0.3
            SequentialAnimation { running: true; loops: Animation.Infinite
                ParallelAnimation {
                    NumberAnimation { target: bigPetal; property: "y"; from: -psize; to: sh + psize; duration: pdur; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: bigPetal; property: "x"; from: px; to: px + psway; duration: pdur; easing.type: Easing.InOutSine }
                    NumberAnimation { target: bigPetal; property: "rotation"; from: 0; to: 720; duration: pdur; easing.type: Easing.Linear }
                }
                PauseAnimation { duration: Math.random() * 1500 }
            }
        }
    }

    // 微风横向吹拂（远景花瓣集体偏移）
    Repeater { model: 40
        Rectangle {
            property real fx: Math.random() * sw
            property real fy: sh * (0.1 + Math.random() * 0.3)
            property real fsize: 4 + Math.random() * 6
            width: fsize; height: fsize * 0.7; radius: fsize * 0.35
            x: fx; y: fy
            color: "#ffd0dc"; opacity: 0.3 + Math.random() * 0.2
            SequentialAnimation on x { loops: Animation.Infinite
                NumberAnimation { from: fx; to: fx + 50; duration: 4000 + Math.random() * 2000; easing.type: Easing.InOutSine }
                NumberAnimation { from: fx + 50; to: fx - 30; duration: 4000 + Math.random() * 2000; easing.type: Easing.InOutSine }
                NumberAnimation { from: fx - 30; to: fx; duration: 4000 + Math.random() * 2000; easing.type: Easing.InOutSine }
            }
        }
    }

    // 底部花瓣堆积
    Repeater { model: 25
        Rectangle {
            property real gx: Math.random() * sw
            property real gsize: 6 + Math.random() * 10
            width: gsize; height: gsize * 0.6; radius: gsize * 0.3
            x: gx; y: sh - gsize * 0.6 - Math.random() * 8
            rotation: Math.random() * 180
            color: "#ff9ab8"; opacity: 0.35 + Math.random() * 0.25
        }
    }
}
