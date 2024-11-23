// A wraper for text
import QtQuick
import QtQuick.Controls
import LingmoUI

Text {
    property color textColor: LingmoTheme.fontPrimaryColor
    id:text
    color: textColor
    renderType: LingmoTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: LingmoTextStyle.Body
}
