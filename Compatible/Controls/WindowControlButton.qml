import QtQuick
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// A single button of WindowControls, drawn like the Lingmo KWin decoration
// (lingmo-kwin-plugins/plugins/decoration/button.cpp): a 16 px coloured circle
// with a hairline ring, grey on an inactive window, and a dark symbol that shows
// while the pointer is over the button group.
Item {
    id: control

    property string kind: "close"      // close | minimize | zoom | restore
    property color accent
    property bool windowActive: true
    // Set by WindowControls: the pointer is over any button of the group
    property bool groupHovered: lit
    readonly property bool lit: _mouse.containsMouse
    readonly property bool pressed: _mouse.pressed
    // Diameter of the circle; the button itself is a 24 px wide cell
    property real diameter: 16
    signal clicked()

    implicitWidth: 24
    implicitHeight: 24

    readonly property bool coloured: windowActive || groupHovered
    readonly property color fill: !coloured ? (LingmoUI.Theme.darkMode ? "#4A4B57" : "#D4D5DA")
                                  : pressed ? Qt.darker(accent, 1.25)
                                  : accent
    readonly property color ring: LingmoUI.Theme.darkMode ? Qt.lighter(fill, 1.15) : Qt.darker(fill, 1.12)
    readonly property bool symbolVisible: groupHovered

    Accessible.role: Accessible.Button
    Accessible.name: kind

    Canvas {
        id: _canvas
        anchors.centerIn: parent
        width: control.diameter + 2
        height: width
        antialiasing: true
        renderStrategy: Canvas.Cooperative

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            const c = width / 2
            const r = control.diameter / 2

            // Circle with a hairline ring a shade darker (lighter in dark mode)
            ctx.beginPath()
            ctx.arc(c, c, r - 0.4, 0, Math.PI * 2)
            ctx.fillStyle = control.fill
            ctx.fill()
            ctx.lineWidth = 0.8
            ctx.strokeStyle = control.ring
            ctx.stroke()

            if (!control.symbolVisible)
                return

            // Symbols: dark ink on the colour
            const ink = Qt.rgba(0, 0, 0, (control.pressed ? 170 : 140) / 255)
            const h = 3.4
            ctx.strokeStyle = ink
            ctx.fillStyle = ink
            ctx.lineWidth = 1.4
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.beginPath()

            if (control.kind === "close") {
                ctx.moveTo(c - h, c - h); ctx.lineTo(c + h, c + h)
                ctx.moveTo(c + h, c - h); ctx.lineTo(c - h, c + h)
                ctx.stroke()
            } else if (control.kind === "minimize") {
                ctx.moveTo(c - h - 0.5, c); ctx.lineTo(c + h + 0.5, c)
                ctx.stroke()
            } else {
                // zoom: two triangles pointing out; restore: pointing in
                const a = 3.8
                if (control.kind === "restore") {
                    const g = 0.6
                    ctx.moveTo(c + g, c - g); ctx.lineTo(c + g + a, c - g); ctx.lineTo(c + g, c - g - a)
                    ctx.closePath()
                    ctx.moveTo(c - g, c + g); ctx.lineTo(c - g - a, c + g); ctx.lineTo(c - g, c + g + a)
                    ctx.closePath()
                } else {
                    const e = a + 1.1
                    ctx.moveTo(c + e - a, c - e); ctx.lineTo(c + e, c - e); ctx.lineTo(c + e, c - e + a)
                    ctx.closePath()
                    ctx.moveTo(c - e + a, c + e); ctx.lineTo(c - e, c + e); ctx.lineTo(c - e, c + e - a)
                    ctx.closePath()
                }
                ctx.fill()
            }
        }
    }

    // Repaint on every state that changes the drawing
    readonly property var _paintState: [fill, ring, symbolVisible, pressed, kind, diameter]
    on_PaintStateChanged: _canvas.requestPaint()

    MouseArea {
        id: _mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: control.clicked()
    }
}
