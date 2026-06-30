import QtQuick

Item {
    id: root

    property string text: ""
    property int fontSize: 42
    property color textColor: "white"
    property color outlineColor: "#222222"
    property int staggerMs: 80
    property int flyDurationMs: 600
    property int animationStyle: 0
    // 0: 四面八方飞入  1: 从下往上弹入  2: 缩放旋转渐入

    implicitHeight: fontSize * 1.3

    ListModel { id: charsModel }

    Item {
        id: charsContainer
        anchors.centerIn: parent
    }

    function _charWidth(c) {
        return (c >= '\u4e00' && c <= '\u9fff') ? fontSize * 1.0 : fontSize * 0.62
    }

    function restart() {
        if (root.text.length === 0) return

        var txt = root.text
        var widths = []
        var totalW = 0
        for (var i = 0; i < txt.length; i++) {
            var w = _charWidth(txt.charAt(i))
            widths.push(w)
            totalW += w
        }
        var startX = -totalW / 2
        var baseY = -fontSize * 0.15

        var chars = []
        for (var j = 0; j < txt.length; j++) {
            var tx = startX, ty = baseY, cw = widths[j]
            startX += cw

            var sx = tx, sy = ty
            if (root.animationStyle === 0) {
                var edge = Math.floor(Math.random() * 4)
                var m = root.fontSize * 10
                if (edge === 0)      { sx = tx; sy = -m }
                else if (edge === 1) { sx = root.width + m + cw; sy = ty }
                else if (edge === 2) { sx = tx; sy = root.height + m }
                else                 { sx = -m - cw; sy = ty }
            } else if (root.animationStyle === 1) {
                sy = root.height + root.fontSize * 3
            }

            chars.push({
                char: txt.charAt(j),
                tx: tx, ty: ty, cw: cw,
                sx: sx, sy: sy,
                delay: j * root.staggerMs
            })
        }

        charsModel.clear()
        for (var k = 0; k < chars.length; k++) {
            charsModel.append(chars[k])
        }
    }

    onTextChanged: {
        if (root.text.length > 0)
            Qt.callLater(root.restart)
    }

    Component {
        id: charDelegate
        Text {
            id: ch
            text: model.char
            width: model.cw
            color: root.textColor
            font.pixelSize: root.fontSize
            font.bold: true
            style: Text.Outline
            styleColor: root.outlineColor
            opacity: 0

            SequentialAnimation {
                id: entryAnim
                running: false
                PauseAnimation { duration: model.delay }
                ParallelAnimation {
                    NumberAnimation { target: ch; property: "x"; from: model.sx; to: model.tx; duration: root.flyDurationMs; easing.type: Easing.OutBack }
                    NumberAnimation { target: ch; property: "y"; from: model.sy; to: model.ty; duration: root.flyDurationMs; easing.type: Easing.OutBack }
                    NumberAnimation { target: ch; property: "opacity"; from: 0; to: 1; duration: Math.floor(root.flyDurationMs * 0.4) }
                    NumberAnimation { target: ch; property: "scale"; from: (root.animationStyle === 2) ? 0 : 1; to: 1; duration: root.flyDurationMs; easing.type: Easing.OutBack }
                    NumberAnimation { target: ch; property: "rotation"; from: (root.animationStyle === 2) ? 360 : 0; to: 0; duration: root.flyDurationMs; easing.type: Easing.OutCubic }
                }
                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation { target: ch; property: "y"; from: model.ty; to: model.ty - 5; duration: 2000; easing.type: Easing.InOutSine }
                    NumberAnimation { target: ch; property: "y"; from: model.ty - 5; to: model.ty; duration: 2000; easing.type: Easing.InOutSine }
                }
            }

            Component.onCompleted: {
                ch.x = model.sx
                ch.y = model.sy
                if (root.animationStyle === 2) {
                    ch.scale = 0
                    ch.rotation = 360
                }
                entryAnim.start()
            }
        }
    }

    Repeater {
        model: charsModel
        parent: charsContainer
        delegate: charDelegate
    }
}
