import QtQuick
import QtQuick.Templates as T
import LingmoUI

// One segment of the segmented control (see TabBar.qml); the selected pill is
// drawn by the TabBar so it can slide between segments
T.TabButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topPadding: 5
    bottomPadding: 5
    leftPadding: 14
    rightPadding: 14

    font.weight: control.checked ? Font.DemiBold : Font.Normal

    contentItem: Text {
        text: control.text
        font: control.font
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.checked ? LingmoTheme.fontPrimaryColor
                               : LingmoTheme.fontSecondaryColor
        opacity: control.enabled ? 1.0 : 0.4

        Behavior on color {
            enabled: LingmoTheme.animationEnabled
            ColorAnimation { duration: 160 }
        }
    }

    background: Rectangle {
        implicitHeight: 28
        radius: 7
        // Subtle hover on unselected segments; the selected one sits on the TabBar's pill
        color: !control.checked && (control.hovered || control.down)
               ? (LingmoTheme.dark ? Qt.rgba(1, 1, 1, control.down ? 0.10 : 0.06)
                                   : Qt.rgba(0, 0, 0, control.down ? 0.07 : 0.04))
               : "transparent"

        Behavior on color {
            enabled: LingmoTheme.animationEnabled
            ColorAnimation { duration: 120 }
        }
    }
}
