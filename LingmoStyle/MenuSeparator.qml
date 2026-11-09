import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts
import LingmoUI.CompatibleModule 3.0 as LUI

T.MenuSeparator {
    id: control

    // Fill the width when placed in a layout (LingmoUI.DesktopMenu uses a ColumnLayout)
    Layout.fillWidth: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 4
    leftPadding: 8
    rightPadding: 8

    contentItem: Rectangle {
        implicitWidth: 180
        implicitHeight: 1
        color: LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.10)
    }
}
