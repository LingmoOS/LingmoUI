import QtQuick
import QtQuick.Templates as T
import LingmoUI.CompatibleModule 3.0 as LUI

T.RadioButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 4
    spacing: 8

    // Accent-filled circle with a white dot when checked
    indicator: Rectangle {
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        implicitWidth: 18
        implicitHeight: 18
        radius: width / 2
        color: control.checked ? LUI.Theme.highlightColor : (LUI.Theme.darkMode ? "#1E1F29" : "#FFFFFF")
        border.width: control.checked ? 0 : 1
        border.color: control.hovered ? (LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.35) : Qt.rgba(0, 0, 0, 0.35))
                                      : (LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.22) : Qt.rgba(0, 0, 0, 0.22))
        opacity: control.enabled ? 1.0 : 0.45

        Behavior on color { ColorAnimation { duration: 140 } }

        Rectangle {
            anchors.centerIn: parent
            width: control.checked ? 7 : 0
            height: width
            radius: width / 2
            color: "white"

            Behavior on width { NumberAnimation { duration: 140; easing.type: Easing.OutBack } }
        }
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: LUI.Theme.textColor
        opacity: control.enabled ? 1.0 : 0.45
    }
}
