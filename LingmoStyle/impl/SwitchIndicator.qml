import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import LingmoUI.CompatibleModule 3.0 as LUI

// Lingmo switch: rounded track in the accent colour when on, white knob with a
// soft shadow that slides across
Item {
    id: indicator
    implicitWidth: 40
    implicitHeight: 24

    property T.AbstractButton control

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: indicator.control.checked ? LUI.Theme.highlightColor
                                         : (LUI.Theme.darkMode ? "#4A4B57" : "#D9DAE0")
        opacity: indicator.control.enabled ? 1.0 : 0.45

        Behavior on color { ColorAnimation { duration: 160 } }
    }

    Rectangle {
        id: knob
        width: parent.height - 4
        height: width
        radius: width / 2
        y: 2
        x: indicator.control.checked ? parent.width - width - 2 : 2
        color: "white"
        visible: false

        Behavior on x {
            enabled: !indicator.control.pressed
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
    }

    MultiEffect {
        source: knob
        anchors.fill: knob
        scale: indicator.control.pressed ? 0.92 : 1.0
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.3)
        shadowBlur: 0.35
        shadowVerticalOffset: 1
        autoPaddingEnabled: true
        opacity: indicator.control.enabled ? 1.0 : 0.7

        Behavior on scale { NumberAnimation { duration: 100 } }
    }
}
