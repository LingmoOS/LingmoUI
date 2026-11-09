import QtQuick
import QtQuick.Templates as T
import LingmoUI.CompatibleModule 3.0 as LUI

T.ProgressBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 6
        clip: true

        // Determinate: rounded fill
        Rectangle {
            visible: !control.indeterminate
            width: control.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: LUI.Theme.highlightColor

            Behavior on width { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }

        // Indeterminate: a segment sweeping across
        Rectangle {
            id: sweep
            visible: control.indeterminate
            width: parent.width * 0.3
            height: parent.height
            radius: height / 2
            color: LUI.Theme.highlightColor

            NumberAnimation on x {
                running: control.indeterminate && control.visible
                loops: Animation.Infinite
                from: -sweep.width
                to: control.width
                duration: 1200
                easing.type: Easing.InOutQuad
            }
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        y: (control.height - height) / 2
        height: 6
        radius: height / 2
        color: LUI.Theme.darkMode ? "#4A4B57" : "#D9DAE0"
    }
}
