import QtQuick

Rectangle {
    id: animationPlayer
    anchors.fill: parent
    color: "#00000000"

    property alias animationSource: contentLoader.source

    Loader {
        id: contentLoader
        anchors.fill: parent
        asynchronous: false
        onLoaded: {
            console.log("[AnimationPlayer] Animation loaded:", source)
        }
    }
}
