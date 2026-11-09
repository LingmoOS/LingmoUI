import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import LingmoUI.CompatibleModule 3.0 as LUI

T.TextArea {
    id: control

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 10
    topPadding: 8
    bottomPadding: 8

    color: LUI.Theme.textColor
    opacity: enabled ? 1.0 : 0.55
    selectionColor: LUI.Theme.highlightColor
    selectedTextColor: "white"
    placeholderTextColor: LUI.Theme.disabledTextColor

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: FieldBackground {
        control: control
        implicitHeight: 64
    }
}
