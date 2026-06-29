import QtQuick
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: appWindow
    visible: true
    opacity: 0
    width: 1
    height: 1
    x: 0
    y: 0
    flags: Qt.SplashScreen | Qt.FramelessWindowHint

    property var overlayWindow: null

    function getOrCreateOverlay() {
        if (overlayWindow) return overlayWindow
        var comp = Qt.createComponent("qrc:/qml/TransparentOverlay.qml")
        if (comp.status === Component.Ready) {
            overlayWindow = comp.createObject(appWindow)
            console.log("[Main] Overlay window created dynamically")
        } else if (comp.status === Component.Error) {
            console.error("[Main] Failed to create overlay:", comp.errorString())
        }
        return overlayWindow
    }

    Loader {
        id: settingsLoader
        active: false
        source: "qrc:/qml/SettingsPanel.qml"
        onLoaded: { item.show() }
    }

    Loader {
        id: recordLoader
        active: false
        source: "qrc:/qml/DrinkRecordPanel.qml"
        onLoaded: { item.show() }
    }

    Loader {
        id: aboutLoader
        active: false
        source: "qrc:/qml/AboutPanel.qml"
        onLoaded: { item.show() }
    }

    Component.onCompleted: {
        console.log("[Main] Application main window loaded")

        bridge.overlayRequested.connect(function(animationPath) {
            console.log("[Main] Overlay requested:", animationPath)
            if (!animationPath) {
                console.warn("[Main] Overlay path is empty, skipping")
                return
            }
            var overlay = getOrCreateOverlay()
            if (overlay) {
                overlay.showOverlay(animationPath)
            }
        })

        bridge.overlayHideRequested.connect(function() {
            console.log("[Main] Overlay hide requested")
            var overlay = getOrCreateOverlay()
            if (overlay) overlay.hideOverlay()
        })

        bridge.settingsPanelRequested.connect(function() {
            console.log("[Main] Settings panel requested")
            if (!settingsLoader.active) {
                settingsLoader.active = true
            } else if (settingsLoader.item) {
                settingsLoader.item.show()
                settingsLoader.item.raise()
            }
        })

        bridge.drinkRecordPanelRequested.connect(function() {
            console.log("[Main] Drink record panel requested")
            if (!recordLoader.active) {
                recordLoader.active = true
            } else if (recordLoader.item) {
                recordLoader.item.show()
                recordLoader.item.raise()
            }
        })

        bridge.aboutPanelRequested.connect(function() {
            console.log("[Main] About panel requested")
            if (!aboutLoader.active) {
                aboutLoader.active = true
            } else if (aboutLoader.item) {
                aboutLoader.item.show()
                aboutLoader.item.raise()
            }
        })
    }
}
