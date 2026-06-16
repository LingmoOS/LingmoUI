import QtQuick
import LingmoUI.GraphicalEffects
import LingmoUI

Item {
    id: control

    property var backgroundTarget: null
    property string backgroundSource: ""

    readonly property bool supportsLiquidGlass: LingmoTools.isOpenGL()
    readonly property Item _effectSourceItem: backgroundTarget ? backgroundTarget : backgroundImageProxy

    property real refraction: 0.0
    property real bevelDepth: 0.052
    property real bevelWidth: 0.211
    property real frost: 2.0
    property real magnify: 1.0
    property bool specular: true
    property bool shadow: true
    property real cornerRadius: 12

    property bool tilt: false
    property real tiltFactor: 5
    property real tiltX: 0
    property real tiltY: 0

    property bool reveal: false
    property real revealProgress: 1.0

    readonly property rect _lensRectInTarget: backgroundTarget
        ? Qt.rect(mapToItem(backgroundTarget, 0, 0).x,
                  mapToItem(backgroundTarget, 0, 0).y,
                  width,
                  height)
        : Qt.rect(0, 0, width, height)

    readonly property rect _captureRect: backgroundTarget
        ? Qt.rect(0, 0, backgroundTarget.width, backgroundTarget.height)
        : Qt.rect(0, 0, Math.max(backgroundImageProxy.width, 1), Math.max(backgroundImageProxy.height, 1))

    default property alias content: contentItem.children

    implicitWidth: 320
    implicitHeight: 200

    function restartReveal() {
        if (!reveal) {
            revealAnimation.stop()
            revealProgress = 1.0
            return
        }
        revealAnimation.stop()
        revealProgress = 0.0
        revealAnimation.start()
    }

    Component.onCompleted: restartReveal()
    onRevealChanged: restartReveal()

    Image {
        id: backgroundImageProxy
        anchors.fill: parent
        source: control.backgroundSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: control.supportsLiquidGlass && !control.backgroundTarget && control.backgroundSource !== ""
        opacity: 0.0
        z: -1000
    }

    Image {
        anchors.fill: parent
        source: control.backgroundSource
        fillMode: Image.PreserveAspectCrop
        visible: !control.supportsLiquidGlass && control.backgroundSource !== ""
    }

    Rectangle {
        anchors.fill: parent
        radius: control.cornerRadius
        color: Qt.rgba(1, 1, 1, 0.14)
        border.width: 0.5
        border.color: Qt.rgba(1, 1, 1, 0.24)
        visible: !control.supportsLiquidGlass && control.backgroundSource === ""
    }

    ShaderEffectSource {
        id: effectSource
        sourceItem: control._effectSourceItem
        sourceRect: control._captureRect
        live: true
        visible: false
        smooth: true
        hideSource: false
    }

    LingmoClip {
        anchors.fill: parent
        radius: new Array(4).fill(control.cornerRadius)
        visible: control.supportsLiquidGlass && (!!control.backgroundTarget || control.backgroundSource !== "")

        ShaderEffect {
            id: glassShader
            anchors.fill: parent

            property variant source: effectSource
            property size resolution: Qt.size(Math.max(width, 1), Math.max(height, 1))
            property size textureResolution: control.backgroundTarget
                ? Qt.size(Math.max(control.backgroundTarget.width, 1), Math.max(control.backgroundTarget.height, 1))
                : Qt.size(Math.max(backgroundImageProxy.width, 1), Math.max(backgroundImageProxy.height, 1))
            property point boundsPosition: control.backgroundTarget
                ? Qt.point(control._lensRectInTarget.x / Math.max(control.backgroundTarget.width, 1),
                           1.0 - ((control._lensRectInTarget.y + control._lensRectInTarget.height) / Math.max(control.backgroundTarget.height, 1)))
                : Qt.point(0, 0)
            property size boundsSize: control.backgroundTarget
                ? Qt.size(control._lensRectInTarget.width / Math.max(control.backgroundTarget.width, 1),
                          control._lensRectInTarget.height / Math.max(control.backgroundTarget.height, 1))
                : Qt.size(1, 1)
            property real refraction: control.refraction
            property real bevelDepth: control.bevelDepth
            property real bevelWidth: control.bevelWidth
            property real frost: control.frost
            property real radius: control.cornerRadius
            property real time: 0.0
            property real specular: control.specular ? 1.0 : 0.0
            property real revealProgress: control.revealProgress
            property real magnify: control.magnify
            property real tiltX: control.tiltX
            property real tiltY: control.tiltY

            fragmentShader: "qrc:/lingmoui/kit/LingmoUI/Shaders/liquidglass.frag.qsb"
        }

        Rectangle {
            anchors.fill: parent
            radius: control.cornerRadius
            color: Qt.rgba(1, 1, 1, 0.035 + Math.min(control.frost / 180.0, 0.025))
        }

        Rectangle {
            anchors.fill: parent
            radius: control.cornerRadius
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.18)
        }

        Rectangle {
            anchors.fill: parent
            radius: control.cornerRadius
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(0, 0, 0, 0.04)
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
        z: 2
        opacity: control.revealProgress
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        anchors.bottomMargin: -2
        z: -1
        radius: control.cornerRadius
        color: Qt.rgba(0, 0, 0, 0.13)
        visible: control.shadow
        opacity: control.revealProgress
    }

    MouseArea {
        anchors.fill: parent
        enabled: control.tilt
        hoverEnabled: true
        onPositionChanged: function(mouse) {
            control.tiltX = (mouse.x / width - 0.5) * 2.0 * control.tiltFactor
            control.tiltY = (mouse.y / height - 0.5) * 2.0 * control.tiltFactor
        }
        onExited: {
            control.tiltX = 0
            control.tiltY = 0
        }
    }

    NumberAnimation {
        id: revealAnimation
        target: control
        property: "revealProgress"
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.OutCubic
    }
}
