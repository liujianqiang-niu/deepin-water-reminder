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

    Component.onCompleted: {
        console.log("[Overlay] Created, screen:", Screen.width, "x", Screen.height)
    }
}
