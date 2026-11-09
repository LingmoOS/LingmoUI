import QtQuick
import QtQuick.Templates as T
import LingmoUI.CompatibleModule 3.0 as LUI

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 6

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 6
    leftPadding: 9
    rightPadding: 9
    topPadding: 5
    bottomPadding: 5
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Text {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: LUI.Theme.textColor
    }

    // Glass like menus and popups (LUI.GlassSurface)
    background: LUI.GlassSurface {
        radius: LUI.Theme.smallRadius
        elevated: true
        sheenEnabled: false
        highlightVisible: false
    }

    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 90 } }
}
