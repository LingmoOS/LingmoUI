/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Gallery of the shared LingmoUI.CompatibleModule components.
 *
 *   qml6 example/compatible-gallery/Gallery.qml
 *   qml6 example/compatible-gallery/Gallery.qml -- /tmp/shot.png   # save a screenshot and quit
 *
 * Light/dark follows the session (com.lingmo.Settings).
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    id: rootWindow
    width: 1180
    height: 860
    minimumWidth: 900
    minimumHeight: 600
    title: qsTr("Gallery")
    visible: true

    background.opacity: 1
    header.height: LingmoUI.Units.windowHeaderHeight
    contentTopMargin: 0

    readonly property string shotPath: {
        const args = Qt.application.arguments
        const last = args[args.length - 1]
        return last.endsWith(".png") ? last : ""
    }

    Timer {
        interval: 1500
        running: rootWindow.shotPath.length > 0
        onTriggered: rootWindow.contentItem.grabToImage(function (result) {
            result.saveToFile(rootWindow.shotPath)
            Qt.quit()
        })
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        LingmoUI.SettingsSideBar {
            id: sideBar
            Layout.fillHeight: true
            searchVisible: true
            iconName: "applications-graphics"
            // "wifi" finds Network through its keywords
            model: ListModel {
                ListElement { title: "Components"; iconName: "applications-graphics"; iconColor: "#0A84FF"; section: ""; badge: ""; keywords: "" }
                ListElement { title: "Network"; iconName: "network-wireless"; iconColor: "#32ADE6"; section: "Tiles"; badge: ""; keywords: "wifi, wireless, internet" }
                ListElement { title: "Notifications"; iconName: "preferences-desktop-notification"; iconColor: "#FF3B30"; section: "Tiles"; badge: "3"; keywords: "alerts" }
                ListElement { title: "Appearance"; iconName: "preferences-desktop-theme"; iconColor: "#5E5CE6"; section: "Tiles"; badge: ""; keywords: "dark mode, theme" }
                ListElement { title: "Inbox"; iconName: "mail-folder-inbox"; iconColor: ""; section: "Plain icons"; badge: "12"; keywords: "" }
                ListElement { title: "Documents"; iconName: "folder-documents"; iconColor: ""; section: "Plain icons"; badge: ""; keywords: "" }
                ListElement { title: "Trash"; iconName: "user-trash"; iconColor: ""; section: "Plain icons"; badge: ""; keywords: "" }
            }
            // A trailing action per row, shown on hover and on the current row
            itemActions: Component {
                LingmoUI.IconButton {
                    iconName: "view-more-symbolic"
                    iconColor: parent.isCurrent ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
                    size: 22
                    iconSize: 12
                    round: true
                    tipText: "More"
                    opacity: parent.hovered || parent.isCurrent ? 1 : 0
                }
            }
        }

        Flickable {
            id: flick
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: column.implicitHeight + LingmoUI.Units.largeSpacing * 2
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}

            ColumnLayout {
                id: column
                x: LingmoUI.Units.largeSpacing * 2
                width: flick.width - LingmoUI.Units.largeSpacing * 4
                spacing: LingmoUI.Units.largeSpacing

                LingmoUI.PageHeader {
                    Layout.fillWidth: true
                    title: "Components"
                    subtitle: "LingmoUI.CompatibleModule 3.0 — " + (LingmoUI.Theme.darkMode ? "dark" : "light")
                    LingmoUI.IconButton { iconName: "view-refresh"; tipText: "Refresh" }
                    LingmoUI.IconButton { iconName: "view-list-details"; checkable: true; checked: true; tipText: "List" }
                    LingmoUI.ActionButton { text: "New"; primary: true; iconName: "list-add" }
                }

                LingmoUI.PageHeader {
                    Layout.fillWidth: true
                    title: "Detail page"
                    large: false
                    backVisible: true
                }

                // iconColor: the icon in a tile, like the sidebar row
                LingmoUI.PageHeader {
                    Layout.fillWidth: true
                    title: "Network"
                    iconName: "network-wireless"
                    iconColor: "#32ADE6"
                }

                LingmoUI.PillTabBar {
                    id: tabs
                    Layout.fillWidth: true
                    model: ListModel {
                        id: tabModel
                        ListElement { title: "~/projects" }
                        ListElement { title: "htop" }
                        ListElement { title: "ssh server" }
                    }
                    currentIndex: 1
                    onCloseRequested: (index) => tabModel.remove(index)
                    onNewTabRequested: tabModel.append({ title: "New tab" })
                }

                LingmoUI.Banner { Layout.fillWidth: true; type: LingmoUI.Banner.Info; text: "Information banner: an update is available." }
                LingmoUI.Banner {
                    Layout.fillWidth: true
                    type: LingmoUI.Banner.Warning
                    title: "Battery low"
                    text: "Connect the charger to keep the update running."
                    closable: false
                    LingmoUI.ActionButton { text: "Details" }
                }
                LingmoUI.Banner { Layout.fillWidth: true; type: LingmoUI.Banner.Error; text: "Could not connect to the server." }
                LingmoUI.Banner { Layout.fillWidth: true; type: LingmoUI.Banner.Success; text: "All files were saved." }

                Text {
                    text: "Buttons"
                    font.pointSize: LingmoUI.Units.fontHeading
                    font.bold: true
                    color: LingmoUI.Theme.textColor
                    Layout.topMargin: LingmoUI.Units.smallSpacing
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.smallSpacing
                    LingmoUI.ActionButton { text: "Cancel" }
                    LingmoUI.ActionButton { text: "Install"; primary: true }
                    LingmoUI.ActionButton { text: "Delete"; destructive: true }
                    LingmoUI.ActionButton { text: "Remove"; destructive: true; subtle: true }
                    LingmoUI.ActionButton { text: "Refresh"; iconName: "view-refresh" }
                    LingmoUI.ActionButton { text: "Saving…"; primary: true; busy: true }
                    LingmoUI.ActionButton { text: "Disabled"; enabled: false }
                    LingmoUI.ActionButton { text: "Skip"; flat: true }
                    LingmoUI.ActionButton { text: "Learn more"; flat: true; primary: true }
                    LingmoUI.IconButton { iconName: "edit-delete"; tipText: "Delete" }
                    LingmoUI.IconButton { iconName: "document-edit"; flat: false; tipText: "Edit" }
                    LingmoUI.IconButton { iconName: "media-playback-start"; round: true; checkable: true; checked: true }
                }

                RowLayout {
                    spacing: LingmoUI.Units.largeSpacing
                    LingmoUI.SegmentedControl { model: ["Day", "Week", "Month"]; currentIndex: 1 }
                    LingmoUI.SegmentedControl {
                        model: [{ text: "Grid", iconName: "view-grid" }, { text: "List", iconName: "view-list-details" }]
                    }
                    LingmoUI.Badge { text: "3" }
                    LingmoUI.Badge { text: "New"; tone: LingmoUI.Theme.greenColor }
                    LingmoUI.Badge { text: "128"; subtle: true }
                    LingmoUI.Badge { dot: true; tone: LingmoUI.Theme.redColor }
                    LingmoUI.Badge { text: "Verified"; tint: LingmoUI.Theme.greenColor; iconName: "emblem-ok-symbolic" }
                    LingmoUI.Badge { text: "Beta"; tint: LingmoUI.Theme.orangeColor }
                    LingmoUI.IconItem { width: 16; height: 16; source: "edit-find-symbolic"; color: LingmoUI.Theme.highlightColor }
                    LingmoUI.IconItem { width: 16; height: 16; source: "user-trash-symbolic"; color: LingmoUI.Theme.redColor }
                    LingmoUI.Spinner {}
                    LingmoUI.BusyIndicator { running: true }
                    BusyIndicator { running: true }
                }

                Text {
                    text: "Cards and type scale"
                    font.pointSize: LingmoUI.Units.fontHeading
                    font.bold: true
                    color: LingmoUI.Theme.textColor
                    Layout.topMargin: LingmoUI.Units.smallSpacing
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.largeSpacing

                    Repeater {
                        model: [
                            { name: "Flat card", elevation: 0, hover: false },
                            { name: "Elevation 1, clickable", elevation: 1, hover: true },
                            { name: "Elevation 2 (popup)", elevation: 2, hover: false }
                        ]
                        LingmoUI.Card {
                            id: card
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 128
                            elevation: modelData.elevation
                            clickable: modelData.hover
                            liftOnHover: modelData.hover
                            highlighted: false

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: card.padding
                                spacing: 2
                                Text { text: card.modelData.name; font.pointSize: LingmoUI.Units.fontSubheading; font.bold: true; color: LingmoUI.Theme.textColor }
                                Text { text: "Body " + LingmoUI.Units.fontBody + "pt — primary text"; font.pointSize: LingmoUI.Units.fontBody; color: LingmoUI.Theme.textColor }
                                Text { text: "Secondary text (secondaryTextColor)"; font.pointSize: LingmoUI.Units.fontBody; color: LingmoUI.Theme.secondaryTextColor }
                                Text { text: "Caption " + LingmoUI.Units.fontCaption + "pt"; font.pointSize: LingmoUI.Units.fontCaption; color: LingmoUI.Theme.secondaryTextColor }
                                Item { Layout.fillHeight: true }
                            }
                        }
                    }
                }

                // Always-light tokens over a picture, and a light button on a banner
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 96
                    radius: LingmoUI.Theme.mediumRadius
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#2B5876" }
                        GradientStop { position: 1.0; color: "#4E4376" }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: LingmoUI.Units.largeSpacing
                        width: overlayLabel.implicitWidth + LingmoUI.Units.largeSpacing * 2
                        height: overlayLabel.implicitHeight + LingmoUI.Units.smallSpacing * 2
                        radius: height / 2
                        color: LingmoUI.Theme.overlayBackgroundColor
                        border.color: LingmoUI.Theme.overlayBorderColor
                        Text {
                            id: overlayLabel
                            anchors.centerIn: parent
                            text: "overlayTextColor on overlayBackgroundColor"
                            color: LingmoUI.Theme.overlayTextColor
                            font.pointSize: LingmoUI.Units.fontBody
                        }
                    }

                    LingmoUI.ActionButton {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: LingmoUI.Units.largeSpacing
                        text: "Get"
                        light: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.largeSpacing

                    // No implicitHeight written: it follows the content
                    LingmoUI.Card {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: LingmoUI.Units.largeSpacing * 1.5
                            spacing: 2
                            Text { text: "Automatic height"; font.pointSize: LingmoUI.Units.fontSubheading; font.bold: true; color: LingmoUI.Theme.textColor }
                            Text { text: "Card sizes itself from its content"; font.pointSize: LingmoUI.Units.fontBody; color: LingmoUI.Theme.secondaryTextColor }
                        }
                    }

                    LingmoUI.Card {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        LingmoUI.EmptyState {
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 32, 360)
                            iconName: "edit-find-symbolic"
                            iconOpacity: 1
                            iconColor: LingmoUI.Theme.highlightColor
                            iconSize: LingmoUI.Units.iconSizes.large
                            title: "No results"
                            text: "iconOpacity: 1 and iconColor on a symbolic icon."
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.largeSpacing

                    LingmoUI.Card {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        LingmoUI.EmptyState {
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 32, 360)
                            iconName: "mail-folder-inbox"
                            title: "No messages"
                            text: "New mail will appear here as soon as it arrives."
                            actionText: "Refresh"
                        }
                    }

                    LingmoUI.Card {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 18
                            spacing: 0
                            Text { text: "Title " + LingmoUI.Units.fontTitle + "pt"; font.pointSize: LingmoUI.Units.fontTitle; font.bold: true; color: LingmoUI.Theme.textColor }
                            Text { text: "Heading " + LingmoUI.Units.fontHeading + "pt"; font.pointSize: LingmoUI.Units.fontHeading; font.bold: true; color: LingmoUI.Theme.textColor }
                            Text { text: "Subheading " + LingmoUI.Units.fontSubheading + "pt"; font.pointSize: LingmoUI.Units.fontSubheading; font.weight: Font.DemiBold; color: LingmoUI.Theme.textColor }
                            Text { text: "Body " + LingmoUI.Units.fontBody + "pt"; font.pointSize: LingmoUI.Units.fontBody; color: LingmoUI.Theme.textColor }
                            Text { text: "Disabled (old secondary) text"; font.pointSize: LingmoUI.Units.fontBody; color: LingmoUI.Theme.disabledTextColor }
                            Text { text: "Font: " + LingmoUI.Theme.fontFamily + " / " + Qt.application.font.family; font.pointSize: LingmoUI.Units.fontCaption; color: LingmoUI.Theme.secondaryTextColor }
                            Item { Layout.fillHeight: true }
                        }
                    }
                }
            }
        }
    }
}
