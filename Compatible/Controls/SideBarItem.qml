/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    SideBarItem: one row of a Lingmo sidebar (as in Settings): optional
    coloured icon tile or plain icon, title, trailing badge/count, hover tint
    and accent highlight when current.

    \qml
    LingmoUI.SideBarItem { title: qsTr("Network"); iconSource: "qrc:/images/wlan.svg"; tileColor: "#0A84FF" }
    LingmoUI.SideBarItem { title: qsTr("Inbox"); iconName: "mail-folder-inbox"; badge: 4; isCurrent: true }
    LingmoUI.SideBarItem { title: qsTr("Work"); iconName: "folder"; indent: 16; trailing: "12" }
    \endqml

    Used by SettingsSideBar; can also be used in your own ListView delegate.
*/
Item {
    id: control

    property string title: ""
    // Theme icon name (plain icon, or drawn in the tile when tileColor is set)
    property string iconName: ""
    // Image url (e.g. white glyph svgs for tiles); wins over iconName
    property url iconSource: ""
    // Background colour of the rounded icon tile; transparent = no tile
    property color tileColor: "transparent"
    // Text in the tile instead of an icon (initials)
    property string tileText: ""
    // Count or short label in a pill on the right (hidden when empty/0)
    property var badge: ""
    // Plain text on the right (counts in mail folders)
    property string trailing: ""
    property bool strongTrailing: false
    property bool isCurrent: false
    property bool emphasized: false
    property int indent: 0
    // Draw the selection background here (false when the ListView draws a highlight)
    property bool drawHighlight: true
    readonly property alias hovered: mouseArea.containsMouse
    readonly property bool hasTile: tileColor.a > 0 || tileText.length > 0
    default property alias extra: extraRow.data

    signal clicked()
    signal rightClicked()

    implicitWidth: LingmoUI.Units.sideBarWidth - LingmoUI.Units.largeSpacing * 2
    implicitHeight: Math.max(LingmoUI.Units.iconTileSize + 8,
                             Math.round(titleLabel.implicitHeight + LingmoUI.Units.largeSpacing * 1.4))

    Accessible.role: Accessible.ListItem
    Accessible.name: title
    Accessible.selected: isCurrent

    Rectangle {
        anchors.fill: parent
        radius: LingmoUI.Theme.mediumRadius
        color: control.isCurrent && control.drawHighlight ? LingmoUI.Theme.highlightColor
             : !control.isCurrent && mouseArea.containsMouse ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g,
                                                                      LingmoUI.Theme.textColor.b, 0.1)
             : "transparent"
        Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton)
                control.rightClicked()
            else
                control.clicked()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: LingmoUI.Units.largeSpacing - (control.hasTile ? 4 : 0) + control.indent
        anchors.rightMargin: LingmoUI.Units.smallSpacing * 1.5
        spacing: LingmoUI.Units.smallSpacing * 1.5

        // Rounded tile in the item's colour, as in Settings
        Rectangle {
            id: tile
            visible: control.hasTile
            Layout.preferredWidth: LingmoUI.Units.iconTileSize
            Layout.preferredHeight: LingmoUI.Units.iconTileSize
            Layout.alignment: Qt.AlignVCenter
            radius: LingmoUI.Units.iconTileRadius
            readonly property color tint: control.tileColor.a > 0 ? control.tileColor : LingmoUI.Theme.highlightColor
            // Same hue in both themes: deeper on light backgrounds, brighter on dark ones
            readonly property color base: LingmoUI.Theme.darkMode ? Qt.lighter(tint, 1.12) : Qt.darker(tint, 1.04)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(tile.base, LingmoUI.Theme.darkMode ? 1.18 : 1.12) }
                GradientStop { position: 1.0; color: tile.base }
            }
            border.width: 1
            border.color: LingmoUI.Theme.darkMode ? Qt.rgba(1, 1, 1, control.isCurrent ? 0.55 : 0.18)
                                                  : Qt.rgba(0, 0, 0, control.isCurrent ? 0.0 : 0.10)

            Image {
                anchors.centerIn: parent
                visible: control.tileText.length === 0 && control.iconSource.toString().length > 0
                width: LingmoUI.Units.iconSizes.small
                height: width
                source: control.iconSource
                sourceSize: Qt.size(width * 2, height * 2)
                smooth: true
                antialiasing: true
            }

            LingmoUI.IconItem {
                anchors.centerIn: parent
                visible: control.tileText.length === 0 && control.iconSource.toString().length === 0
                         && control.iconName.length > 0
                width: LingmoUI.Units.iconSizes.small
                height: width
                source: control.iconName
            }

            Text {
                anchors.centerIn: parent
                visible: control.tileText.length > 0
                text: control.tileText
                color: "white"
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontCaption
                font.bold: true
            }
        }

        // Plain icon (no tile)
        Image {
            visible: !control.hasTile && control.iconSource.toString().length > 0
            source: control.iconSource
            Layout.preferredWidth: LingmoUI.Units.iconSizes.small
            Layout.preferredHeight: LingmoUI.Units.iconSizes.small
            Layout.alignment: Qt.AlignVCenter
            sourceSize: Qt.size(width * 2, height * 2)
        }

        LingmoUI.IconItem {
            visible: !control.hasTile && control.iconSource.toString().length === 0 && control.iconName.length > 0
            source: control.iconName
            Layout.preferredWidth: LingmoUI.Units.iconSizes.small
            Layout.preferredHeight: LingmoUI.Units.iconSizes.small
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: titleLabel
            text: control.title
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontBody
            font.weight: control.emphasized ? Font.Bold : Font.Normal
            color: control.isCurrent ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
            elide: Text.ElideRight
            textFormat: Text.PlainText
            renderType: LingmoUI.Theme.renderType
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: control.trailing.length > 0
            text: control.trailing
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontCaption
            font.bold: control.strongTrailing
            color: control.isCurrent ? LingmoUI.Theme.highlightedTextColor
                 : control.strongTrailing ? LingmoUI.Theme.highlightColor : LingmoUI.Theme.secondaryTextColor
            renderType: LingmoUI.Theme.renderType
            Layout.alignment: Qt.AlignVCenter
        }

        LingmoUI.Badge {
            text: control.badge === undefined || control.badge === null ? "" : String(control.badge)
            inverted: control.isCurrent
            Layout.alignment: Qt.AlignVCenter
        }

        RowLayout {
            id: extraRow
            spacing: 0
            visible: children.length > 0
        }
    }
}
