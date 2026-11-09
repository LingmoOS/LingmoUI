/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import LingmoUI.CompatibleModule as LingmoUI

/*!
    GlassSurface: the "Vidro Lingmo" material.

    KWin blurs what is behind the window (_KDE_NET_WM_BLUR_BEHIND_REGION,
    requested here through WindowBlur); on top of the blur the surface draws

      - a tint (Theme.glassTint at Theme.glassOpacity, light or dark),
      - a hairline border (Theme.glassBorderColor),
      - a 1 px inner highlight along the top and left edges (Theme.glassHighlight),
      - a faint grain (a tiled texture, Theme.glassNoiseOpacity),
      - an optional soft elevation (Theme.glassElevation),
      - at the Strong level only, a light sheen under the pointer while it
        hovers (Theme.glassSheen; never with "reduce motion").

    Everything follows Settings > Appearance > Glass (Theme.glassLevel) live.
    With Glass off, or without a compositor, it is a solid surface.

    Nothing animates while idle: the highlight and grain are painted once per
    size change, the sheen only moves with the pointer.

    \qml
    // A popup window: the surface fills it and asks KWin for the blur
    Window {
        color: "transparent"
        LingmoUI.GlassSurface {
            anchors.fill: parent
            radius: LingmoUI.Theme.hugeRadius
            // children go on top
            Label { anchors.centerIn: parent; text: "Hello" }
        }
    }

    // A floating panel inside a bigger transparent window
    LingmoUI.GlassSurface { x: 20; y: 20; width: 300; height: 200; elevated: true }
    \endqml

    KWin keeps one blur region per window, so by default (blurMode Auto) a
    surface only asks for the blur when it fills its window (popup windows,
    panels, the status bar). A surface that floats inside a bigger transparent
    window sets blurMode: GlassSurface.Always; Never leaves the window's blur
    alone (e.g. inside a LingmoUI.Window that asks for it already). A surface
    that does not get a blur turns almost opaque so what is under it does not
    show through sharp.
*/
Item {
    id: control

    enum BlurMode { Auto, Always, Never }

    // Corner radius (0 for edge-to-edge bars)
    property real radius: LingmoUI.Theme.hugeRadius

    // When to ask KWin to blur behind this surface (see the note above)
    property int blurMode: 0 // GlassSurface.Auto
    // false turns the blur request off whatever blurMode says
    property bool blurBehind: true
    // The window to blur; the surface's own window by default
    property var blurWindow: control.Window.window

    // Drop a soft shadow inside the window (for panels that float inside a
    // bigger transparent window; window-sized surfaces use WindowShadow)
    property bool elevated: false

    // Parts of the material
    property bool borderVisible: true
    property bool highlightVisible: true
    property bool noiseVisible: true
    property bool sheenEnabled: true

    // Force a solid surface whatever the level
    property bool solid: false
    // What is behind is already blurred by the app itself (a fullscreen
    // launcher or lock screen over its own blurred wallpaper): keep the glass
    // translucency without asking KWin for a blur
    property bool backdropBlurred: false

    // Material values (override for a special surface)
    property color tint: LingmoUI.Theme.glassTint
    property real tintOpacity: LingmoUI.Theme.glassOpacity
    property color borderColor: LingmoUI.Theme.glassBorderColor
    property color highlightColor: LingmoUI.Theme.glassHighlight

    // Read-only state
    readonly property bool glass: LingmoUI.Theme.glassEnabled && !solid
    readonly property int level: glass ? LingmoUI.Theme.glassLevel : LingmoUI.Theme.glassOff
    // KWin blurs behind this surface
    readonly property bool blurring: _blur.enabled
    readonly property color surfaceColor: Qt.rgba(tint.r, tint.g, tint.b,
                                                  !glass ? 1.0 : (blurring || backdropBlurred) ? tintOpacity
                                                                                               : Math.max(tintOpacity, 0.95))
    readonly property bool hovered: _hover.hovered

    default property alias content: _content.data

    // Recompute the blur region when the surface moves inside its window
    function updateBlurRect() {
        _blur.blurRect = control._blurRect()
    }

    // Coalesced and safe after destruction (unlike Qt.callLater on a
    // function of a deleted object)
    Timer {
        id: _blurRectTimer
        interval: 0
        onTriggered: control.updateBlurRect()
    }

    property bool _fillsWindow: false

    function _blurRect() {
        const w = control.blurWindow
        if (!w || !control.visible) {
            control._fillsWindow = false
            return Qt.rect(0, 0, 0, 0)
        }
        const p = control.mapToItem(null, 0, 0)
        // Window-sized: let WindowBlur follow the window's size by itself
        control._fillsWindow = Math.abs(p.x) < 2 && Math.abs(p.y) < 2
                && control.width >= w.width - 2 && control.height >= w.height - 2
        if (control._fillsWindow)
            return Qt.rect(0, 0, 0, 0)
        return Qt.rect(p.x, p.y, control.width, control.height)
    }

    onXChanged: _blurRectTimer.restart()
    onYChanged: _blurRectTimer.restart()
    onWidthChanged: _blurRectTimer.restart()
    onHeightChanged: _blurRectTimer.restart()
    onVisibleChanged: _blurRectTimer.restart()
    onBlurWindowChanged: _blurRectTimer.restart()

    LingmoUI.WindowBlur {
        id: _blur
        view: control.blurWindow
        enabled: control.blurBehind && control.glass && !control.backdropBlurred && control.visible && control.blurWindow !== null
                 && (control.blurMode === 1 /* Always */
                     || (control.blurMode === 0 /* Auto */ && control._fillsWindow))
        windowRadius: control.radius
        Component.onCompleted: control.updateBlurRect()
    }

    // Soft elevation
    RectangularShadow {
        anchors.fill: _base
        visible: control.elevated && control.visible
        radius: control.radius
        blur: LingmoUI.Theme.glassElevation.blur
        offset: Qt.vector2d(0, LingmoUI.Theme.glassElevation.yOffset)
        color: Qt.rgba(0, 0, 0, LingmoUI.Theme.glassElevation.opacity)
        spread: 0
        cached: true
    }

    // Tint and hairline
    Rectangle {
        id: _base
        anchors.fill: parent
        radius: control.radius
        color: control.surfaceColor
        antialiasing: control.radius > 0
        border.width: control.borderVisible ? 1 / Math.max(1, LingmoUI.Theme.devicePixelRatio) : 0
        border.color: control.borderColor

        Behavior on color { ColorAnimation { duration: LingmoUI.Units.longDuration; easing.type: LingmoUI.Units.easing } }
    }

    // Grain and the top/left inner highlight, painted once per size or colour
    // change (not per frame). Only created while it has something to draw.
    Loader {
        anchors.fill: parent
        active: control.visible && control.glass && control.width > 1 && control.height > 1
                && ((control.highlightVisible && control.highlightColor.a > 0)
                    || (control.noiseVisible && LingmoUI.Theme.glassNoiseOpacity > 0))
        sourceComponent: Canvas {
            id: _detail
            renderStrategy: Canvas.Cooperative

            readonly property url noiseUrl: Qt.resolvedUrl("../images/glass-noise.png")
            property bool noiseReady: false

            Component.onCompleted: loadImage(noiseUrl)
            onImageLoaded: { noiseReady = true; schedule() }

            function schedule() { _paintTimer.restart() }

            Timer {
                id: _paintTimer
                interval: 0
                onTriggered: _detail.requestPaint()
            }

            onWidthChanged: schedule()
            onHeightChanged: schedule()

            Connections {
                target: control
                function onRadiusChanged() { _detail.schedule() }
                function onHighlightColorChanged() { _detail.schedule() }
                function onLevelChanged() { _detail.schedule() }
            }
            Connections {
                target: LingmoUI.Theme
                function onDarkModeChanged() { _detail.schedule() }
            }

            onPaint: {
                const ctx = getContext("2d")
                ctx.reset()
                const w = width, h = height
                if (w < 2 || h < 2)
                    return
                const r = Math.min(control.radius, w / 2, h / 2)

                if (control.noiseVisible && noiseReady && LingmoUI.Theme.glassNoiseOpacity > 0) {
                    ctx.save()
                    ctx.beginPath()
                    ctx.roundedRect(0, 0, w, h, r, r)
                    ctx.clip()
                    ctx.globalAlpha = LingmoUI.Theme.glassNoiseOpacity
                    ctx.fillStyle = ctx.createPattern(noiseUrl, "repeat")
                    ctx.fillRect(0, 0, w, h)
                    ctx.restore()
                }

                if (control.highlightVisible && control.highlightColor.a > 0) {
                    // Light from the top left: full along the top edge, fading down
                    // the left side, gone before the bottom and right edges
                    const c = control.highlightColor
                    const g = ctx.createLinearGradient(0, 0, w * 0.25, h * 0.9)
                    g.addColorStop(0.0, Qt.rgba(c.r, c.g, c.b, c.a))
                    g.addColorStop(0.45, Qt.rgba(c.r, c.g, c.b, c.a * 0.35))
                    g.addColorStop(1.0, Qt.rgba(c.r, c.g, c.b, 0))
                    ctx.strokeStyle = g
                    ctx.lineWidth = 1
                    const inset = 1.5
                    ctx.beginPath()
                    ctx.roundedRect(inset, inset, w - inset * 2, h - inset * 2,
                                    Math.max(0, r - inset + 0.5), Math.max(0, r - inset + 0.5))
                    ctx.stroke()
                }
            }
        }
    }

    // Light sheen under the pointer (Strong only, while hovering; nothing
    // runs or is drawn otherwise)
    HoverHandler {
        id: _hover
        enabled: control.sheenEnabled && LingmoUI.Theme.glassSheen && control.glass
    }

    Loader {
        id: _sheenLoader
        anchors.fill: parent
        active: _hover.enabled && (_hover.hovered || opacity > 0)
        opacity: _hover.hovered ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: LingmoUI.Units.longDuration; easing.type: LingmoUI.Units.easing } }

        sourceComponent: Shape {
            id: _sheen
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: -1
                fillGradient: RadialGradient {
                    centerX: _hover.point.position.x
                    centerY: _hover.point.position.y
                    focalX: centerX
                    focalY: centerY
                    centerRadius: Math.max(80, Math.min(control.width, control.height) * 0.9)
                    focalRadius: 0
                    GradientStop { position: 0.0; color: LingmoUI.Theme.glassSheenColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                PathRectangle {
                    x: 0; y: 0
                    width: _sheen.width
                    height: _sheen.height
                    radius: control.radius
                }
            }
        }
    }

    Item {
        id: _content
        anchors.fill: parent
    }
}
