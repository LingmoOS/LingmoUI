import QtQuick
import LingmoUI

Item {
    id: control

    // ── Background image (file path, like the original LiquidGlass) ──
    property string backgroundSource: ""

    // ── Glass lens shape ──
    property real powerFactor: 3.0
    property real glassWidth: 3.5
    property real glassHeight: 3.5

    // ── Refraction curve ──
    property real refractionA: 0.7
    property real refractionB: 2.3
    property real refractionC: 5.2
    property real refractionD: 6.9
    property real refractionPower: 1.0

    // ── Blur ──
    property real blurRadius: 2.0
    property int blurIterations: 1
    property real blurDownscale: 0.5

    // ── Visual effects ──
    property real noiseStrength: 0.06
    property real glowWeight: 0.25
    property real glowBias: 0.0
    property real glowEdge0: 0.5
    property real glowEdge1: -0.5

    // ── Interaction ──
    property bool mouseControl: false
    property point glassPosition: Qt.point(0.5, 0.5)

    // ── Styling ──
    property int cornerRadius: LingmoUnits.windowRadius

    // Controller — all glass parameters
    LiquidGlassController {
        id: glassController
        backgroundSource: control.backgroundSource
        powerFactor: control.powerFactor
        a: control.refractionA
        b: control.refractionB
        c: control.refractionC
        d: control.refractionD
        fPower: control.refractionPower
        noise: control.noiseStrength
        glowWeight: control.glowWeight
        glowBias: control.glowBias
        glowEdge0: control.glowEdge0
        glowEdge1: control.glowEdge1
        blurRadius: control.blurRadius
        blurIters: control.blurIterations
        blurDownscaleFactor: control.blurDownscale
        glassWidth: control.glassWidth
        glassHeight: control.glassHeight
        mouseControl: control.mouseControl
    }

    // OpenGL-rendered glass morphism lens
    LiquidGlassView {
        id: glassView
        anchors.fill: parent
        controller: glassController
    }

    // Sync glass position
    Connections {
        target: control
        function onGlassPositionChanged() {
            glassController.setMousePosition(control.glassPosition.x, control.glassPosition.y)
        }
    }
}
