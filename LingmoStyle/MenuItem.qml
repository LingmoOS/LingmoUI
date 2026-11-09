import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Layouts
import LingmoUI.CompatibleModule 3.0 as LUI

T.MenuItem {
    id: control

    // Fill the width when placed in a layout (LingmoUI.DesktopMenu uses a ColumnLayout)
    Layout.fillWidth: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    leftPadding: 10
    rightPadding: 10
    topPadding: 5
    bottomPadding: 5
    spacing: 8

    // DesktopMenu places items in a plain layout, where "highlighted" is never set:
    // follow the mouse too
    readonly property bool lit: control.highlighted || control.hovered || control.down
    readonly property color ink: !control.enabled ? LUI.Theme.disabledTextColor
                                 : lit ? "white" : LUI.Theme.textColor

    icon.width: 16
    icon.height: 16
    icon.color: ink

    contentItem: IconLabel {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        leftPadding: !control.mirrored ? indicatorPadding : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        color: control.ink
    }

    // Submenu arrow: a small chevron
    arrow: Item {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 8
        height: 10
        visible: control.subMenu

        Repeater {
            model: [40, -40]
            Rectangle {
                x: 1
                y: modelData > 0 ? 2.4 : 5.6
                width: 6; height: 1.5; radius: 0.75
                rotation: control.mirrored ? -modelData + 180 : modelData
                color: control.ink
                antialiasing: true
            }
        }
    }

    // Check mark for checkable items
    indicator: Item {
        x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: control.checkable ? 14 : 0
        height: 14
        visible: control.checkable && control.checked

        Rectangle {
            x: 1; y: 7
            width: 5; height: 1.6; radius: 0.8
            rotation: 45
            transformOrigin: Item.Left
            color: control.ink
            antialiasing: true
        }
        Rectangle {
            x: 4.5; y: 10.5
            width: 9; height: 1.6; radius: 0.8
            rotation: -50
            transformOrigin: Item.Left
            color: control.ink
            antialiasing: true
        }
    }

    background: Rectangle {
        implicitWidth: 180
        implicitHeight: 30
        radius: 6
        color: control.lit ? LUI.Theme.highlightColor : "transparent"
        opacity: control.down ? 0.85 : 1.0
    }
}
