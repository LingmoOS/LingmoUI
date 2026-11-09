import QtQuick
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// Lingmo window controls: close, minimize and zoom drawn like the KWin
// decoration (lingmo-kwin-plugins): 16 px coloured circles in 24 px cells,
// grey while the window is inactive, symbols shown while the pointer is over
// the group.
Item {
    id: control

    property bool windowActive: true
    property bool maximized: false
    property bool minimizeVisible: true
    property bool zoomVisible: true
    // The pointer is over one of the buttons
    readonly property bool hovered: _close.lit || _minimize.lit || _zoom.lit

    signal closeClicked()
    signal minimizeClicked()
    signal zoomClicked()

    implicitWidth: _row.implicitWidth
    implicitHeight: 24

    Row {
        id: _row
        height: parent.height
        spacing: 0

        WindowControlButton {
            id: _close
            kind: "close"
            accent: "#F2555A"
            height: parent.height
            windowActive: control.windowActive
            groupHovered: control.hovered
            onClicked: control.closeClicked()
        }

        WindowControlButton {
            id: _minimize
            kind: "minimize"
            accent: "#F5A524"
            height: parent.height
            windowActive: control.windowActive
            groupHovered: control.hovered
            visible: control.minimizeVisible
            onClicked: control.minimizeClicked()
        }

        WindowControlButton {
            id: _zoom
            kind: control.maximized ? "restore" : "zoom"
            accent: "#2F7CF6"
            height: parent.height
            windowActive: control.windowActive
            groupHovered: control.hovered
            visible: control.zoomVisible
            onClicked: control.zoomClicked()
        }
    }
}
