import QtQuick

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent
    property real sw: Screen.width
    property real sh: Screen.height

    // 暗色夜空
    Rectangle { width: sw; height: sh * 0.3
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#050510" }
            GradientStop { position: 0.5; color: "#0a0a20" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.6
    }

    // 极光帘幕
    Repeater { model: 7
        Rectangle { id: curtain; property real cx: sw * (0.05 + index * 0.14 + Math.random() * 0.02)
            width: sw * 0.12; height: sh * 0.55; x: cx; radius: width / 3
            rotation: -4 + index * 1.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: index % 3 === 0 ? "#22ff88" : (index % 3 === 1 ? "#4488ff" : "#cc44ff") }
                GradientStop { position: 0.3; color: index % 3 === 0 ? "#119944" : (index % 3 === 1 ? "#2255aa" : "#6622aa") }
                GradientStop { position: 0.7; color: index % 3 === 0 ? "#0a5522" : (index % 3 === 1 ? "#112266" : "#331166") }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.12 + index * 0.03
            SequentialAnimation on opacity { loops: Animation.Infinite
                NumberAnimation { from: 0.08 + index * 0.02; to: 0.22 + index * 0.03; duration: 6000 + index * 1200; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.22 + index * 0.03; to: 0.08 + index * 0.02; duration: 5000 + index * 1000; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on x { loops: Animation.Infinite
                NumberAnimation { from: cx; to: cx + 15 + index * 3; duration: 8000 + index * 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: cx + 15 + index * 3; to: cx - 10; duration: 7000 + index * 1200; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on rotation { loops: Animation.Infinite
                NumberAnimation { from: -4 + index * 1.5; to: -2 + index * 1.5; duration: 7000 + index * 1000; easing.type: Easing.InOutSine }
                NumberAnimation { from: -2 + index * 1.5; to: -6 + index * 1.5; duration: 7000 + index * 1000; easing.type: Easing.InOutSine }
            }
        }
    }

    // 极光辉光
    Rectangle { width: sw * 0.9; height: sh * 0.08; x: sw * 0.05; y: sh * 0.25; radius: height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.2; color: "#44ff88" }
            GradientStop { position: 0.5; color: "#8844ff" }
            GradientStop { position: 0.8; color: "#4488ff" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.15
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.10; to: 0.22; duration: 7000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.22; to: 0.10; duration: 7000; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on y { loops: Animation.Infinite
            NumberAnimation { from: sh * 0.25; to: sh * 0.22; duration: 6000; easing.type: Easing.InOutSine }
            NumberAnimation { from: sh * 0.22; to: sh * 0.28; duration: 6000; easing.type: Easing.InOutSine }
        }
    }

    // 星点
    Repeater { model: 60
        Rectangle { width: 0.8 + Math.random() * 1.5; height: width; radius: width / 2
            x: Math.random() * sw; y: Math.random() * sh; color: "#ffffff"; opacity: 0.1
            SequentialAnimation on opacity { loops: Animation.Infinite
                PauseAnimation { duration: Math.random() * 5000 }
                NumberAnimation { from: 0.05; to: 0.6; duration: 600 + Math.random() * 1500 }
                NumberAnimation { from: 0.6; to: 0.05; duration: 600 + Math.random() * 1500 }
            }
        }
    }

    // 底部散射光
    Rectangle { width: sw; height: sh * 0.15; y: sh * 0.5
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#114422" }
            GradientStop { position: 0.5; color: "#112244" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.2
        SequentialAnimation on opacity { loops: Animation.Infinite
            NumberAnimation { from: 0.15; to: 0.25; duration: 8000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.25; to: 0.15; duration: 8000; easing.type: Easing.InOutSine }
        }
    }
}
