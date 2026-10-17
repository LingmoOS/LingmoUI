/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import LingmoUI.CompatibleModule as LingmoUI

/*!
    SettingsSideBar: the left navigation of Lingmo Settings, for any app with
    more than one section. Empty strip for the window buttons at the top, the
    app title in big bold type, an optional search field, then the items
    (grouped by section headers when the model has a "section" role).

    \qml
    RowLayout {
        anchors.fill: parent
        spacing: 0

        LingmoUI.SettingsSideBar {
            id: sideBar
            Layout.fillHeight: true
            searchVisible: true
            model: ListModel {
                ListElement { title: qsTr("Overview"); iconSource: "qrc:/images/home.svg"; iconColor: "#0A84FF"; section: "" }
                ListElement { title: qsTr("Inbox"); iconName: "mail-folder-inbox"; badge: "4"; section: qsTr("Mail") }
            }
        }

        StackLayout { currentIndex: sideBar.currentIndex; Layout.fillWidth: true; Layout.fillHeight: true }
    }
    \endqml

    Model roles (all optional except title):
      title, iconName (theme icon), iconSource (image url), iconColor (tile
      colour; without it the icon is drawn plain), section, badge (count or
      short text), trailing (plain trailing text), enabled (false hides it).
    Any QAbstractItemModel/ListModel works. The title defaults to the
    window title.
*/
Item {
    id: control

    property string title: Window.window ? Window.window.title : ""
    property var model
    property alias currentIndex: listView.currentIndex
    property alias view: listView
    // Role used for section headers ("" disables them)
    property string sectionRole: "section"
    // Draw icons inside coloured tiles when the item has an iconColor
    property bool tiles: true
    // Search field under the title; items are filtered by title
    property bool searchVisible: false
    property alias searchText: searchField.text
    property alias searchPlaceholder: searchField.placeholderText
    // Height of the strip kept free for the window buttons
    property real windowControlsHeight: (Window.window && Window.window.header !== undefined && Window.window.header)
                                        ? Window.window.header.height : LingmoUI.Units.windowHeaderHeight
    // Background (Theme.sideBarColor); set to "transparent" over a blurred window
    property color backgroundColor: LingmoUI.Theme.sideBarColor
    // Optional item at the bottom (account box, storage meter...)
    property Component footer: null

    signal itemClicked(int index)
    signal itemRightClicked(int index)
    signal searchAccepted(string text)

    implicitWidth: LingmoUI.Units.sideBarWidth

    Rectangle {
        anchors.fill: parent
        color: control.backgroundColor
        Behavior on color { ColorAnimation { duration: LingmoUI.Units.longDuration; easing.type: Easing.Linear } }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // The window's close / minimize / zoom buttons sit in this strip
        Item {
            Layout.preferredHeight: control.windowControlsHeight
            Layout.fillWidth: true
        }

        Text {
            visible: control.title.length > 0
            text: control.title
            color: (Window.window && !Window.window.active) ? LingmoUI.Theme.secondaryTextColor : LingmoUI.Theme.textColor
            leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            topPadding: 2
            bottomPadding: LingmoUI.Units.smallSpacing * 1.5
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontTitle
            font.bold: true
            // Long names shrink a little instead of being cut
            fontSizeMode: Text.HorizontalFit
            minimumPointSize: LingmoUI.Units.fontSubheading
            renderType: LingmoUI.Theme.renderType
            Layout.fillWidth: true
        }

        TextField {
            id: searchField
            visible: control.searchVisible
            placeholderText: qsTr("Search")
            selectByMouse: true
            leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.iconSizes.small
            Layout.fillWidth: true
            Layout.leftMargin: LingmoUI.Units.largeSpacing
            Layout.rightMargin: LingmoUI.Units.largeSpacing
            Layout.bottomMargin: LingmoUI.Units.smallSpacing * 1.5
            onAccepted: control.searchAccepted(text)
            Keys.onEscapePressed: text = ""

            // Magnifier, drawn so it doesn't depend on the icon theme
            Item {
                x: LingmoUI.Units.smallSpacing + 2
                anchors.verticalCenter: parent.verticalCenter
                width: 14
                height: 14
                opacity: 0.6
                Rectangle {
                    x: 0; y: 0; width: 10; height: 10; radius: 5
                    color: "transparent"
                    border.width: 1.6
                    border.color: LingmoUI.Theme.textColor
                }
                Rectangle {
                    x: 8; y: 10.5; width: 6; height: 1.6; radius: 0.8
                    rotation: 45
                    color: LingmoUI.Theme.textColor
                }
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: control.model

            spacing: LingmoUI.Units.smallSpacing
            leftMargin: LingmoUI.Units.largeSpacing
            rightMargin: LingmoUI.Units.largeSpacing
            bottomMargin: LingmoUI.Units.largeSpacing
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationEnabled: true

            ScrollBar.vertical: ScrollBar {}

            // Selection: drawn by the view so it can follow the current item
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration: 0
            highlight: Rectangle {
                radius: LingmoUI.Theme.mediumRadius
                color: LingmoUI.Theme.highlightColor
                visible: listView.currentItem !== null && listView.currentItem.visible
            }

            section.property: control.searchText.length > 0 ? "" : control.sectionRole
            section.criteria: ViewSection.FullString
            section.delegate: Item {
                required property string section
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: section.length > 0 ? sectionLabel.implicitHeight + LingmoUI.Units.largeSpacing : 0
                visible: section.length > 0

                Text {
                    id: sectionLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: LingmoUI.Units.smallSpacing
                    anchors.bottomMargin: 2
                    text: parent.section
                    color: LingmoUI.Theme.secondaryTextColor
                    font.family: LingmoUI.Theme.fontFamily
                    font.pointSize: LingmoUI.Units.fontCaption
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    renderType: LingmoUI.Theme.renderType
                }
            }

            LingmoUI.WheelHandler {
                target: listView
            }

            delegate: LingmoUI.SideBarItem {
                id: item
                required property int index
                required property var model

                readonly property bool matches: {
                    const q = control.searchText.trim().toLowerCase()
                    return q.length === 0 || String(model.title || "").toLowerCase().indexOf(q) !== -1
                }

                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                visible: matches && model.enabled !== false
                height: visible ? implicitHeight : 0

                title: model.title || ""
                iconName: model.iconName || ""
                iconSource: model.iconSource || ""
                tileColor: control.tiles && model.iconColor ? model.iconColor : "transparent"
                badge: model.badge !== undefined ? model.badge : ""
                trailing: model.trailing !== undefined ? String(model.trailing) : ""
                isCurrent: listView.currentIndex === index
                drawHighlight: false

                onClicked: {
                    listView.currentIndex = index
                    control.itemClicked(index)
                }
                onRightClicked: control.itemRightClicked(index)
            }
        }

        Loader {
            active: control.footer !== null
            sourceComponent: control.footer
            visible: active
            Layout.fillWidth: true
            Layout.leftMargin: LingmoUI.Units.largeSpacing
            Layout.rightMargin: LingmoUI.Units.largeSpacing
            Layout.bottomMargin: LingmoUI.Units.largeSpacing
        }
    }
}
