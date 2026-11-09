import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import LingmoUI

// Segmented control: a rounded track with a pill that slides to the selected tab
T.TabBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 3
    spacing: 0

    readonly property int radius: 9

    contentItem: ListView {
        model: control.contentModel
        currentIndex: control.currentIndex

        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        interactive: false

        highlightFollowsCurrentItem: true
        highlightMoveDuration: LingmoTheme.animationEnabled ? 240 : 0
        highlightMoveVelocity: -1
        highlightResizeDuration: highlightMoveDuration
        highlightResizeVelocity: -1

        highlight: Item {
            z: -1

            Rectangle {
                id: pill
                anchors.fill: parent
                radius: control.radius - control.padding + 1
                color: LingmoTheme.dark ? Qt.rgba(1, 1, 1, 0.20) : "#FFFFFF"
                border.width: LingmoTheme.dark ? 0 : 0.5
                border.color: Qt.rgba(0, 0, 0, 0.08)
                visible: false
            }

            MultiEffect {
                source: pill
                anchors.fill: pill
                shadowEnabled: !LingmoTheme.dark
                shadowColor: Qt.rgba(0, 0, 0, 0.22)
                shadowBlur: 0.35
                shadowVerticalOffset: 1
                shadowHorizontalOffset: 0
                autoPaddingEnabled: true
            }
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 34
        radius: control.radius
        color: LingmoTheme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.06)
    }
}
