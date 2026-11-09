import QtQuick
import QtQuick.Templates as T
import LingmoUI

// macOS-like overlay scroll bar: a thin rounded thumb that widens under the
// mouse, shown while scrolling and fading out shortly after
T.ScrollBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: orientation === Qt.Horizontal ? height / width : width / height

    readonly property bool wide: control.hovered || control.pressed

    contentItem: Rectangle {
        implicitWidth: control.wide ? 9 : 6
        implicitHeight: control.wide ? 9 : 6
        radius: Math.min(width, height) / 2
        color: LingmoTheme.dark ? Qt.rgba(1, 1, 1, control.pressed ? 0.55 : 0.40)
                                : Qt.rgba(0, 0, 0, control.pressed ? 0.50 : 0.35)
        opacity: 0.0

        Behavior on implicitWidth { NumberAnimation { duration: 120 } }
        Behavior on implicitHeight { NumberAnimation { duration: 120 } }
    }

    background: Rectangle {
        implicitWidth: control.wide ? 13 : 10
        implicitHeight: control.wide ? 13 : 10
        radius: Math.min(width, height) / 2
        // A faint track only while the mouse is over the bar
        color: LingmoTheme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.04)
        visible: control.size < 1.0
        opacity: control.wide ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    states: State {
        name: "active"
        when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
        PropertyChanges { control.contentItem.opacity: 1.0 }
    }

    transitions: Transition {
        from: "active"
        SequentialAnimation {
            PauseAnimation { duration: 900 }
            NumberAnimation { target: control.contentItem; property: "opacity"; to: 0.0; duration: 300 }
        }
    }
}
