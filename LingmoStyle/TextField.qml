import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import LingmoUI.CompatibleModule 3.0 as LUI

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    leftPadding: 10
    rightPadding: 10
    topPadding: 6
    bottomPadding: 6

    color: LUI.Theme.textColor
    opacity: enabled ? 1.0 : 0.55
    selectionColor: LUI.Theme.highlightColor
    selectedTextColor: "white"
    placeholderTextColor: LUI.Theme.disabledTextColor
    verticalAlignment: TextInput.AlignVCenter

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
    }
}
