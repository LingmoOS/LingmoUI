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
      short text), trailing (plain trailing text), enabled (false hides it),
      keywords (extra search terms: a string or a list of strings).
    Any QAbstractItemModel/ListModel works. The title defaults to the
    window title.

    \qml
    // App icon before the title, keyword search, a "more" button per row
    LingmoUI.SettingsSideBar {
        iconName: "internet-mail"
        searchVisible: true
        itemActions: Component {
            LingmoUI.IconButton {
                // parent is the per-row slot: parent.index, parent.model,
                // parent.hovered, parent.isCurrent
                iconName: "view-more-symbolic"
                size: 22; iconSize: 12
                visible: parent.hovered
                onClicked: accountMenu.popupFor(parent.index)
            }
        }
    }

    // Custom header (replaces the icon + title row)
    LingmoUI.SettingsSideBar { header: Component { MyAccountSwitcher {} } }
    \endqml
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
    // App icon before the title (theme icon name, or an image url)
    property string iconName: ""
    property url iconSource: ""
    // Replaces the icon + title row (account switcher, logo...)
    property Component header: null
    // Search field under the title; items whose searchRoles contain the text
    // are kept (roles may hold a string or a list of strings)
    property bool searchVisible: false
    property var searchRoles: ["title", "keywords"]
    property alias searchText: searchField.text
    property alias searchPlaceholder: searchField.placeholderText
    // Height of the strip kept free for the window buttons
    property real windowControlsHeight: (Window.window && Window.window.header !== undefined && Window.window.header)
                                        ? Window.window.header.height : LingmoUI.Units.windowHeaderHeight
    // Background (Theme.sideBarColor); set to "transparent" over a blurred window
    property color backgroundColor: LingmoUI.Theme.sideBarColor
    // Optional item at the bottom (account box, storage meter...)
    property Component footer: null
    // Per-row trailing actions; the component's parent exposes index, model,
    // hovered and isCurrent of its row
    property Component itemActions: null
    // Vertical space between rows (also between rows left after a search)
    property real spacing: LingmoUI.Units.smallSpacing
    // Number of rows matching the current search (all enabled rows without one)
    readonly property alias matchCount: internal.matchCount

    function matches(model) {
        const q = control.searchText.trim().toLowerCase()
        if (q.length === 0)
            return true
        for (const role of control.searchRoles) {
            const value = model[role]
            if (value === undefined || value === null)
                continue
            const values = Array.isArray(value) || (typeof value === "object" && value.length !== undefined)
                         ? Array.from(value) : [value]
            for (const v of values) {
                if (String(v).toLowerCase().indexOf(q) !== -1)
                    return true
            }
        }
        return false
    }

    // Index of the first row matching the search (-1 if none)
    function firstMatch() {
        for (let i = 0; i < listView.count; ++i) {
            const it = listView.itemAtIndex(i)
            if (it && it.matches && it.rowEnabled)
                return i
        }
        return -1
    }

    signal itemClicked(int index)
    signal itemRightClicked(int index)
    signal searchAccepted(string text)

    implicitWidth: LingmoUI.Units.sideBarWidth

    QtObject {
        id: internal
        property int matchCount: 0

        function countMatches() {
            let n = 0
            for (let i = 0; i < listView.count; ++i) {
                const it = listView.itemAtIndex(i)
                if (it && it.matches && it.rowEnabled)
                    ++n
            }
            matchCount = n
        }
    }

    onSearchTextChanged: Qt.callLater(internal.countMatches)
    Connections {
        target: listView
        function onCountChanged() { Qt.callLater(internal.countMatches) }
    }

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

        // Custom header
        Loader {
            active: control.header !== null
            visible: active
            sourceComponent: control.header
            Layout.fillWidth: true
            Layout.leftMargin: LingmoUI.Units.largeSpacing
            Layout.rightMargin: LingmoUI.Units.largeSpacing
            Layout.bottomMargin: LingmoUI.Units.smallSpacing * 1.5
        }

        // App icon and title
        RowLayout {
            visible: control.header === null
                     && (control.title.length > 0 || control.iconName.length > 0 || control.iconSource.toString().length > 0)
            spacing: LingmoUI.Units.smallSpacing * 1.5
            Layout.fillWidth: true
            Layout.leftMargin: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            Layout.rightMargin: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            Layout.topMargin: 2
            Layout.bottomMargin: LingmoUI.Units.smallSpacing * 1.5

            LingmoUI.IconItem {
                visible: control.iconSource.toString().length > 0 || control.iconName.length > 0
                source: control.iconSource.toString().length > 0 ? control.iconSource : control.iconName
                Layout.preferredWidth: LingmoUI.Units.iconSizes.medium
                Layout.preferredHeight: LingmoUI.Units.iconSizes.medium
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                id: titleLabel
                visible: control.title.length > 0
                text: control.title
                color: (Window.window && !Window.window.active) ? LingmoUI.Theme.secondaryTextColor : LingmoUI.Theme.textColor
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontTitle
                font.bold: true
                // Long names shrink a little instead of being cut
                fontSizeMode: Text.HorizontalFit
                minimumPointSize: LingmoUI.Units.fontSubheading
                renderType: LingmoUI.Theme.renderType
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
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

            // Rows carry their own gap (control.spacing) so rows hidden by a
            // search don't leave double gaps behind
            spacing: 0
            cacheBuffer: 4000
            leftMargin: LingmoUI.Units.largeSpacing
            rightMargin: LingmoUI.Units.largeSpacing
            bottomMargin: LingmoUI.Units.largeSpacing
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationEnabled: true

            ScrollBar.vertical: ScrollBar {}

            // Selection: drawn by the view so it can follow the current item
            // (over the row only, not the gap under it)
            highlightFollowsCurrentItem: false
            highlight: Rectangle {
                readonly property Item target: listView.currentItem
                x: target ? target.x : 0
                y: target ? target.y : 0
                width: target ? target.width : 0
                height: !target ? 0 : target.rowHeight !== undefined ? target.rowHeight : target.height
                radius: LingmoUI.Theme.mediumRadius
                color: LingmoUI.Theme.highlightColor
                visible: target !== null && target.visible
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

            delegate: Item {
                id: row
                required property int index
                required property var model

                readonly property bool matches: control.matches(model)
                readonly property bool rowEnabled: model.enabled !== false
                readonly property real rowHeight: item.implicitHeight
                readonly property alias sideBarItem: item

                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                visible: matches && rowEnabled
                height: visible ? item.implicitHeight + control.spacing : 0

                onMatchesChanged: Qt.callLater(internal.countMatches)

                LingmoUI.SideBarItem {
                    id: item
                    width: parent.width
                    height: implicitHeight

                    title: row.model.title || ""
                    iconName: row.model.iconName || ""
                    iconSource: row.model.iconSource || ""
                    tileColor: control.tiles && row.model.iconColor ? row.model.iconColor : "transparent"
                    badge: row.model.badge !== undefined ? row.model.badge : ""
                    trailing: row.model.trailing !== undefined ? String(row.model.trailing) : ""
                    isCurrent: listView.currentIndex === row.index
                    drawHighlight: false

                    onClicked: {
                        listView.currentIndex = row.index
                        control.itemClicked(row.index)
                    }
                    onRightClicked: control.itemRightClicked(row.index)

                    // Per-row actions; the loaded item reads parent.index etc.
                    Loader {
                        id: actionsLoader
                        readonly property int index: row.index
                        readonly property var model: row.model
                        readonly property bool hovered: item.hovered || (actionsLoader.item && actionsLoader.item.hovered === true)
                        readonly property bool isCurrent: item.isCurrent
                        active: control.itemActions !== null
                        visible: active
                        sourceComponent: control.itemActions
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
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
