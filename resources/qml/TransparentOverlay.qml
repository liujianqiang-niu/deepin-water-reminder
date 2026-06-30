import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: overlayWindow

    width: Screen.width
    height: Screen.height
    x: 0
    y: 0

    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    visible: false

    property int duration: bridge.settings ? bridge.settings.animationDuration * 1000 : 6000

    function shake(intensity) {
        shakeAnim.from = -intensity
        shakeAnim.to = intensity
        shakeAnim.duration = 50
        shakeAnim.loops = 2
        shakeAnim.restart()
    }

    NumberAnimation {
        id: shakeAnim
        target: overlayWindow
        property: "x"
        duration: 50
        loops: 2
        onFinished: { overlayWindow.x = 0 }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            console.log("[Overlay] Clicked — recording drink")
            bridge.onUserDismissed()
        }
    }

    Timer {
        id: autoHideTimer
        interval: duration
        running: false
        repeat: false
        onTriggered: {
            console.log("[Overlay] Auto-hide fired")
            hideOverlay()
        }
    }

    function showOverlay(animPath) {
        console.log("[Overlay] showOverlay called, path:", animPath)
        // Always force fullscreen on primary screen
        var screen = Qt.application.screens[0]
        overlayWindow.screen = screen
        overlayWindow.x = screen.virtualX
        overlayWindow.y = screen.virtualY
        overlayWindow.width = screen.width
        overlayWindow.height = screen.height
        if (animPath) {
            animationLoader.source = ""
            animationLoader.source = animPath
        }
        overlayWindow.show()
        overlayWindow.raise()
        overlayWindow.requestActivate()
        autoHideTimer.restart()
        // 强制重新触发文字入场动画（每次显示都重新播放）
        quoteLayer.restart()
        messageLayer.restart()
    }

    function hideOverlay() {
        console.log("[Overlay] hideOverlay called")
        overlayWindow.hide()
        autoHideTimer.stop()
        animationLoader.source = ""
    }

    Loader {
        id: animationLoader
        anchors.fill: parent
        asynchronous: false
        onLoaded: {
            console.log("[Overlay] Animation loaded:", source)
        }
        onStatusChanged: {
            if (status === Loader.Error) {
                console.error("[Overlay] Loader error:", source)
            }
        }
    }

    // 文字层优先级：自定义提醒文案 > 趣味语录 > 不显示
    property bool hasCustomMessage: bridge && bridge.settings ? (String(bridge.settings.reminderMessage || "").length > 0) : false
    property bool showQuotes: bridge && bridge.settings ? (bridge.settings.showQuotes === true) : false

    // 趣味话语文字层（透明背景 + 逐字飞入动画；点击穿透）
    AnimatedText {
        id: quoteLayer
        visible: !overlayWindow.hasCustomMessage && overlayWindow.showQuotes
        enabled: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(100, parent.height * 0.18)
        text: bridge && bridge.currentQuote ? bridge.currentQuote : ""
        fontSize: 42
        animationStyle: bridge && bridge.settings ? (bridge.settings.textAnimationStyle || 0) : 0
        textColor: "white"
        outlineColor: "#222222"
    }

    // 自定义提醒文案层（透明背景 + 逐字飞入动画；优先级最高）
    AnimatedText {
        id: messageLayer
        visible: overlayWindow.hasCustomMessage
        enabled: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(100, parent.height * 0.18)
        text: bridge && bridge.settings ? (bridge.settings.reminderMessage || "") : ""
        fontSize: 42
        animationStyle: bridge && bridge.settings ? (bridge.settings.textAnimationStyle || 0) : 0
        textColor: "white"
        outlineColor: "#222222"
    }

    Component.onCompleted: {
        console.log("[Overlay] Created, screen:", Screen.width, "x", Screen.height)
    }
}
