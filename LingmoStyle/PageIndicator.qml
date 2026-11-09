import QtQuick
import QtQuick.Templates as T
import LingmoUI.CompatibleModule 3.0 as LUI

T.PageIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 8

    // The current page is a short pill, the others dots
    delegate: Rectangle {
        implicitWidth: index === control.currentIndex ? 18 : 7
        implicitHeight: 7
        radius: height / 2
        color: index === control.currentIndex ? LUI.Theme.highlightColor
                                              : (LUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.35) : Qt.rgba(0, 0, 0, 0.25))
        opacity: pressed ? 0.7 : 1.0

        required property int index
        required property bool pressed

        Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 180 } }
    }

    contentItem: Row {
        spacing: control.spacing

        Repeater {
            model: control.count
            delegate: control.delegate
        }
    }
}
