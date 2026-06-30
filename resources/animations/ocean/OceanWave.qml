import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height

    // 海洋深处氛围光
    Rectangle {
        width: sw * 1.2; height: sh * 0.55
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0055aa" }
            GradientStop { position: 0.3; color: "#003d7a" }
            GradientStop { position: 0.6; color: "#002255" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.35
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.30; to: 0.40; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.40; to: 0.30; duration: 4000; easing.type: Easing.InOutSine }
        }
    }

    // 光柱
    Repeater { model: 4
        Rectangle { id: shaft; property real sx: sw * (0.2 + index * 0.2 + Math.random() * 0.1)
            property real w: sw * 0.04 + Math.random() * sw * 0.03
            width: w; height: sh * 0.4; x: sx; y: sh * 0.35
            rotation: Math.random() > 0.5 ? 8 : -8; radius: width / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0088cc" }
                GradientStop { position: 0.5; color: "#006699" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.08 + index * 0.02
            SequentialAnimation on opacity { loops: Animation.Infinite
                NumberAnimation { from: 0.06 + index * 0.02; to: 0.14 + index * 0.02; duration: 5000 + index * 800; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.14 + index * 0.02; to: 0.06 + index * 0.02; duration: 5000 + index * 800; easing.type: Easing.InOutSine }
            }
        }
    }

    // 深层波浪
    Repeater { model: 4
        Rectangle { id: deepWave; property real dx: Math.random() * sw * 0.3
            property real baseY: sh * (0.50 + index * 0.04)
            width: sw * 1.4; height: sh * 0.035; x: dx - sw * 0.2; radius: height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#003366" }
                GradientStop { position: 0.5; color: "#004488" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.2 + index * 0.03
            SequentialAnimation on x { loops: Animation.Infinite
                NumberAnimation { from: dx - sw * 0.2; to: dx - sw * 0.2 - 40; duration: 7000 + index * 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: dx - sw * 0.2 - 40; to: dx - sw * 0.2; duration: 7000 + index * 1500; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on y { loops: Animation.Infinite
                NumberAnimation { from: baseY; to: baseY - 12; duration: 6000 + index * 1000; easing.type: Easing.InOutSine }
                NumberAnimation { from: baseY - 12; to: baseY + 8; duration: 6000 + index * 1000; easing.type: Easing.InOutSine }
            }
        }
    }

    // 中层波浪
    Repeater { model: 5
        Rectangle { id: midWave; property real mx: Math.random() * sw * 0.2
            property real baseY: sh * (0.55 + index * 0.035)
            width: sw * 1.3; height: sh * 0.03; x: mx - sw * 0.15; radius: height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0088bb" }
                GradientStop { position: 0.5; color: "#0099dd" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.22 + index * 0.04
            SequentialAnimation on x { loops: Animation.Infinite
                NumberAnimation { from: mx - sw * 0.15; to: mx - sw * 0.15 - 25; duration: 5500 + index * 800; easing.type: Easing.InOutSine }
                NumberAnimation { from: mx - sw * 0.15 - 25; to: mx - sw * 0.15 + 15; duration: 5500 + index * 800; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on y { loops: Animation.Infinite
                NumberAnimation { from: baseY; to: baseY - 18; duration: 4500 + index * 600; easing.type: Easing.InOutSine }
                NumberAnimation { from: baseY - 18; to: baseY + 10; duration: 4500 + index * 600; easing.type: Easing.InOutSine }
            }
        }
    }

    // 前景波浪
    Repeater { model: 4
        Rectangle { id: frontWave; property real fx: Math.random() * sw * 0.15
            property real baseY: sh * (0.62 + index * 0.04)
            width: sw * 1.2; height: sh * 0.025; x: fx - sw * 0.1; radius: height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00bbee" }
                GradientStop { position: 0.4; color: "#00ccff" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.25 + index * 0.05
            SequentialAnimation on x { loops: Animation.Infinite
                NumberAnimation { from: fx - sw * 0.1; to: fx - sw * 0.1 - 30; duration: 4000 + index * 700; easing.type: Easing.InOutSine }
                NumberAnimation { from: fx - sw * 0.1 - 30; to: fx - sw * 0.1 + 20; duration: 4000 + index * 700; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on y { loops: Animation.Infinite
                NumberAnimation { from: baseY; to: baseY - 22; duration: 3500 + index * 500; easing.type: Easing.InOutSine }
                NumberAnimation { from: baseY - 22; to: baseY + 12; duration: 3500 + index * 500; easing.type: Easing.InOutSine }
            }
        }
    }

    // 浪花泡沫
    Repeater { model: 50
        Rectangle { id: foam; property real sx: Math.random() * sw
            property real rh: 40 + Math.random() * 120
            property real dur: 2000 + Math.random() * 3000
            property real baseY: sh * (0.60 + Math.random() * 0.15)
            width: 2 + Math.random() * 4; height: width; radius: width / 2
            x: sx; color: "#ffffff"
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 4000 }
                ParallelAnimation {
                    NumberAnimation { target: foam; property: "y"; from: baseY; to: baseY - rh; duration: dur; easing.type: Easing.OutQuad }
                    NumberAnimation { target: foam; property: "x"; from: sx; to: sx + (Math.random() - 0.5) * 80; duration: dur; easing.type: Easing.InOutSine }
                }
                SequentialAnimation {
                    NumberAnimation { target: foam; property: "opacity"; from: 0; to: 0.7; duration: dur * 0.15 }
                    NumberAnimation { target: foam; property: "opacity"; from: 0.7; to: 0; duration: dur * 0.85 }
                }
            }
        }
    }

    // 水下气泡
    Repeater { model: 20
        Rectangle { id: bubble; property real bx: Math.random() * sw
            property real br: 3 + Math.random() * 8
            property real dur: 4000 + Math.random() * 5000
            property real baseY: sh * (0.75 + Math.random() * 0.2)
            width: br; height: br; radius: br / 2; x: bx; color: "#aaeeff"; opacity: 0
            SequentialAnimation { running: true; loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 3000 }
                ParallelAnimation {
                    NumberAnimation { target: bubble; property: "y"; from: baseY; to: sh * 0.5; duration: dur; easing.type: Easing.OutQuad }
                    NumberAnimation { target: bubble; property: "x"; from: bx; to: bx + (Math.random() - 0.5) * 40; duration: dur; easing.type: Easing.InOutSine }
                }
                SequentialAnimation {
                    NumberAnimation { target: bubble; property: "opacity"; from: 0; to: 0.5; duration: dur * 0.1 }
                    NumberAnimation { target: bubble; property: "opacity"; from: 0.5; to: 0; duration: dur * 0.9 }
                }
            }
        }
    }

    // 水面反光
    Rectangle { width: sw; height: sh * 0.04; anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0088aa" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.15
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.10; to: 0.20; duration: 3000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.20; to: 0.10; duration: 3000; easing.type: Easing.InOutSine }
        }
    }
}
