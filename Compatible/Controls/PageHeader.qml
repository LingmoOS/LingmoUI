/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    PageHeader: the title row of a page: optional back button and icon,
    title, optional subtitle, trailing actions.

    \qml
    LingmoUI.PageHeader {
        Layout.fillWidth: true
        title: qsTr("Storage")
        subtitle: qsTr("128 GB free of 512 GB")
        LingmoUI.IconButton { iconName: "view-refresh"; tipText: qsTr("Refresh") }   // trailing actions
    }

    // Window without a sidebar: the header shares the top strip with the
    // window buttons, so keep their space free
    LingmoUI.PageHeader { title: qsTr("Clock"); reserveWindowControls: true }

    // Detail page
    LingmoUI.PageHeader { title: app.name; backVisible: true; onBack: stack.pop() }
    \endqml

    Its minimum height is Units.windowHeaderHeight so it lines up with the
    window's header strip when placed at the top.
*/
Item {
    id: control

    property string title: ""
    property string subtitle: ""
    // Theme icon name (or url) before the title
    property string iconName: ""
    property int iconSize: subtitle.length > 0 ? LingmoUI.Units.iconSizes.medium : LingmoUI.Units.iconSizes.smallMedium
    property bool backVisible: false
    property string backTipText: qsTr("Back")
    // Leave room on the left for the window's close/minimize/zoom buttons
    property bool reserveWindowControls: false
    // Large title (sidebar-less app pages) vs. smaller detail-pane title
    property bool large: true
    property alias leftPadding: row.anchors.leftMargin
    property alias rightPadding: row.anchors.rightMargin
    default property alias actions: actionsRow.data

    signal back()

    implicitWidth: row.implicitWidth + row.anchors.leftMargin + row.anchors.rightMargin
    implicitHeight: Math.max(LingmoUI.Units.windowHeaderHeight, row.implicitHeight + LingmoUI.Units.smallSpacing * 2)

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: (control.reserveWindowControls ? LingmoUI.Units.windowControlsInset : 0)
        anchors.rightMargin: 0
        spacing: LingmoUI.Units.smallSpacing * 1.5

        LingmoUI.IconButton {
            visible: control.backVisible
            tipText: control.backTipText
            Layout.alignment: Qt.AlignVCenter
            onClicked: control.back()

            // Drawn chevron: independent of the icon theme
            Item {
                anchors.centerIn: parent
                width: 10
                height: 12
                Rectangle {
                    x: 2; y: 3.2; width: 8; height: 1.8; radius: 0.9
                    rotation: -45
                    color: LingmoUI.Theme.textColor
                }
                Rectangle {
                    x: 2; y: 7.2; width: 8; height: 1.8; radius: 0.9
                    rotation: 45
                    color: LingmoUI.Theme.textColor
                }
            }
        }

        LingmoUI.IconItem {
            visible: control.iconName.length > 0
            source: control.iconName
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                text: control.title
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: control.large ? LingmoUI.Units.fontHeading : LingmoUI.Units.fontSubheading
                font.weight: Font.Bold
                color: LingmoUI.Theme.textColor
                elide: Text.ElideRight
                renderType: LingmoUI.Theme.renderType
                Layout.fillWidth: true
            }

            Text {
                visible: control.subtitle.length > 0
                text: control.subtitle
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontCaption
                color: LingmoUI.Theme.secondaryTextColor
                elide: Text.ElideRight
                renderType: LingmoUI.Theme.renderType
                Layout.fillWidth: true
            }
        }

        RowLayout {
            id: actionsRow
            spacing: LingmoUI.Units.smallSpacing
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
