/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    SegmentedControl: a row of mutually exclusive pill tabs (Optimizer,
    Settings' font size picker...).

    \qml
    LingmoUI.SegmentedControl {
        model: [qsTr("Day"), qsTr("Week"), qsTr("Month")]
        currentIndex: 1
        onActivated: (index) => chart.range = index
    }
    // with icons: model entries can be objects
    LingmoUI.SegmentedControl {
        model: [{ text: qsTr("Grid"), iconName: "view-grid" }, { text: qsTr("List"), iconName: "view-list-details" }]
    }
    \endqml

    The selected pill slides between segments. Set fillWidth: true to stretch
    the segments over the whole width.
*/
Rectangle {
    id: control

    // Strings, or objects { text, iconName }
    property var model: []
    property int currentIndex: 0
    // Stretch segments to equal widths over the control's width
    property bool fillWidth: false
    readonly property int count: repeater.count

    signal activated(int index)

    implicitHeight: Math.round(LingmoUI.Units.fontMetrics.height + LingmoUI.Units.largeSpacing * 1.3)
    implicitWidth: row.implicitWidth + 6
    radius: LingmoUI.Theme.smallRadius + 2
    color: LingmoUI.Theme.alternateBackgroundColor
    border.width: 1
    border.color: LingmoUI.Theme.dividerColor

    Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }

    Accessible.role: Accessible.PageTabList

    // Sliding selection pill
    Rectangle {
        id: pill
        readonly property Item target: repeater.count > 0 && control.currentIndex >= 0
                                       ? repeater.itemAt(Math.min(control.currentIndex, repeater.count - 1)) : null
        visible: target !== null
        x: target ? row.x + target.x : 0
        y: row.y
        width: target ? target.width : 0
        height: row.height
        radius: LingmoUI.Theme.smallRadius
        color: LingmoUI.Theme.highlightColor

        Behavior on x { NumberAnimation { duration: LingmoUI.Units.shortDuration; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: LingmoUI.Units.shortDuration; easing.type: Easing.OutCubic } }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 3
        spacing: 3

        Repeater {
            id: repeater
            model: control.model

            delegate: Item {
                id: segment
                required property int index
                required property var modelData
                readonly property bool selected: control.currentIndex === index
                readonly property string label: typeof modelData === "object" && modelData !== null
                                                ? (modelData.text || "") : String(modelData)
                readonly property string icon: typeof modelData === "object" && modelData !== null
                                               ? (modelData.iconName || "") : ""

                Layout.fillWidth: control.fillWidth
                Layout.fillHeight: true
                Layout.preferredWidth: control.fillWidth ? 1 : implicitWidth
                implicitWidth: content.implicitWidth + LingmoUI.Units.largeSpacing * 2

                Accessible.role: Accessible.PageTab
                Accessible.name: label
                Accessible.checked: selected

                Rectangle {
                    anchors.fill: parent
                    radius: LingmoUI.Theme.smallRadius
                    color: !segment.selected && mouse.containsMouse ? LingmoUI.Theme.hoverColor : "transparent"
                    Behavior on color { ColorAnimation { duration: LingmoUI.Units.veryShortDuration } }
                }

                Row {
                    id: content
                    anchors.centerIn: parent
                    spacing: LingmoUI.Units.smallSpacing

                    LingmoUI.IconItem {
                        visible: segment.icon.length > 0
                        source: segment.icon
                        width: LingmoUI.Units.iconSizes.small
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: segment.label
                        visible: text.length > 0
                        font.family: LingmoUI.Theme.fontFamily
                        font.pointSize: LingmoUI.Units.fontBody
                        font.weight: segment.selected ? Font.DemiBold : Font.Normal
                        color: segment.selected ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
                        renderType: LingmoUI.Theme.renderType
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (control.currentIndex !== segment.index) {
                            control.currentIndex = segment.index
                            control.activated(segment.index)
                        }
                    }
                }
            }
        }
    }
}
