import QtQuick
import QtQuick.Templates as T
import LingmoUI

T.Label {
    id: control

    opacity: enabled ? 1.0 : 0.4
    // LingmoTheme follows the system light/dark scheme
    color: LingmoTheme.fontPrimaryColor
    linkColor: LingmoTheme.primaryColor
}
