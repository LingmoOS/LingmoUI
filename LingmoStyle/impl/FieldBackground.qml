import QtQuick
import LingmoUI.CompatibleModule 3.0 as LUI

// Shared background for text inputs: rounded field, hairline border, and a soft
// accent focus ring outside it
Rectangle {
    id: bg

    property Item control
    readonly property bool focused: control && control.activeFocus

    implicitWidth: 120
    implicitHeight: 32
    radius: 8
    color: LUI.Theme.darkMode ? "#1E1F29" : "#FFFFFF"
    opacity: control && !control.enabled ? 0.55 : 1.0
    border.width: 1
    border.color: focused ? LUI.Theme.highlightColor
                          : control && control.hovered
                            ? (LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.24) : Qt.rgba(0, 0, 0, 0.24))
                            : (LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.14))

    Behavior on border.color { ColorAnimation { duration: 120 } }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: parent.radius + 3
        color: "transparent"
        border.width: 3
        border.color: LUI.Theme.highlightColor
        opacity: bg.focused ? 0.28 : 0
        visible: opacity > 0

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
}
