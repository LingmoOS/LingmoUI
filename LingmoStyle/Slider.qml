import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import LingmoUI.CompatibleModule 3.0 as LUI

T.Slider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)

    padding: 4

    // White knob with a soft shadow, a touch bigger while dragged
    handle: Item {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 20
        implicitHeight: 20

        Rectangle {
            id: knob
            anchors.fill: parent
            radius: width / 2
            color: "white"
            border.width: 0.5
            border.color: Qt.rgba(0, 0, 0, 0.12)
            visible: false
        }

        MultiEffect {
            source: knob
            anchors.fill: knob
            scale: control.pressed ? 1.12 : 1.0
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.28)
            shadowBlur: 0.4
            shadowVerticalOffset: 1
            autoPaddingEnabled: true

            Behavior on scale { NumberAnimation { duration: 120 } }
        }
    }

    background: Item {
        x: control.leftPadding
        y: control.topPadding
        implicitWidth: control.horizontal ? 200 : 20
        implicitHeight: control.horizontal ? 20 : 200
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight
        scale: control.horizontal && control.mirrored ? -1 : 1
        opacity: control.enabled ? 1.0 : 0.45

        // Track
        Rectangle {
            x: control.horizontal ? 0 : (parent.width - width) / 2
            y: control.horizontal ? (parent.height - height) / 2 : 0
            width: control.horizontal ? parent.width : 4
            height: control.horizontal ? 4 : parent.height
            radius: 2
            color: LUI.Theme.darkMode ? "#4A4B57" : "#D9DAE0"
        }

        // Filled part up to the handle
        Rectangle {
            x: control.horizontal ? 0 : (parent.width - width) / 2
            y: control.horizontal ? (parent.height - height) / 2 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : 4
            height: control.horizontal ? 4 : control.position * parent.height
            radius: 2
            color: LUI.Theme.highlightColor
        }
    }
}
