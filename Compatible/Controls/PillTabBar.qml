/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    PillTabBar: closable tabs drawn as pills (terminal, editor and browser-like
    tabs), with an optional "new tab" button. Fits in the window's header
    strip (Window.headerItem) or anywhere in the content.

    \qml
    LingmoUI.PillTabBar {
        Layout.fillWidth: true
        model: documents                         // ListModel with a "title" role
        currentIndex: editor.currentIndex        // stays bound (two-way, like SegmentedControl)
        onActivated: (index) => editor.currentIndex = index
        onCloseRequested: (index) => editor.close(index)
        onNewTabRequested: editor.newDocument()
    }

    // Count model + text from a function
    LingmoUI.PillTabBar {
        model: tabView.count
        textProvider: (index) => tabView.contentModel.get(index).title
    }
    \endqml

    Model: a number, a list of strings or of objects { title, iconName }, or a
    model with textRole/iconRole roles. Every tab gets the same width, between
    tabMinimumWidth and tabMaximumWidth; long titles are elided. The close
    button shows on the current and the hovered tab; middle click closes too.
    The space after the tabs is left free so the window can be dragged by it.
*/
Item {
    id: control

    property var model
    property int currentIndex: 0
    // Role names for item models
    property string textRole: "title"
    property string iconRole: "iconName"
    // Optional function (index, modelData) -> text, wins over the model
    property var textProvider: null
    property bool closable: true
    property bool newTabVisible: true
    property string newTabTipText: qsTr("New Tab")
    property string closeTipText: qsTr("Close Tab")
    property real tabMinimumWidth: LingmoUI.Units.gridUnit * 4
    property real tabMaximumWidth: LingmoUI.Units.gridUnit * 13
    // Space kept free after the tabs (to drag the window by)
    property real reservedWidth: LingmoUI.Units.largeSpacing * 4
    readonly property int count: _list.count
    readonly property alias view: _list

    // A tab was clicked (index differs from currentIndex)
    signal activated(int index)
    signal closeRequested(int index)
    signal newTabRequested()

    implicitHeight: LingmoUI.Units.windowHeaderHeight - LingmoUI.Units.smallSpacing
    implicitWidth: _row.implicitWidth

    // Selects index as if it was clicked (emits activated). Same two-way
    // pattern as SegmentedControl: a binding on currentIndex is kept.
    function activate(index) {
        if (index < 0 || index >= count || index === currentIndex)
            return
        internal.pendingIndex = index
        control.activated(index)
        internal.pendingIndex = -1
    }

    QtObject {
        id: internal
        property int pendingIndex: -1
    }

    Binding {
        target: control
        property: "currentIndex"
        value: internal.pendingIndex
        when: internal.pendingIndex >= 0
        restoreMode: Binding.RestoreBinding
    }

    RowLayout {
        id: _row
        anchors.fill: parent
        spacing: LingmoUI.Units.smallSpacing

        // Every tab gets the same width
        readonly property real tabWidth: {
            const free = _row.width - (_newTab.visible ? _newTab.width + _row.spacing : 0)
                       - control.reservedWidth - _list.spacing * Math.max(0, _list.count - 1)
            return Math.max(control.tabMinimumWidth,
                            Math.min(control.tabMaximumWidth, free / Math.max(1, _list.count)))
        }

        ListView {
            id: _list
            Layout.fillHeight: true
            Layout.preferredWidth: contentWidth
            Layout.maximumWidth: Math.max(0, _row.width - (_newTab.visible ? _newTab.width + _row.spacing : 0)
                                             - control.reservedWidth)
            orientation: ListView.Horizontal
            spacing: LingmoUI.Units.smallSpacing / 2
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            interactive: contentWidth > width
            model: control.model
            currentIndex: control.currentIndex
            highlightMoveDuration: LingmoUI.Units.shortDuration

            delegate: Item {
                id: _tab

                required property int index
                required property var modelData
                readonly property bool checked: control.currentIndex === index
                readonly property bool hovered: _tabMouse.containsMouse || _closeMouse.containsMouse
                readonly property var entry: modelData
                readonly property string title: {
                    if (control.textProvider)
                        return String(control.textProvider(index, entry) || "")
                    if (entry === undefined || entry === null || typeof entry === "number")
                        return ""
                    if (typeof entry === "object")
                        return String(entry[control.textRole] || "")
                    return String(entry)
                }
                readonly property string icon: entry !== null && typeof entry === "object"
                                               ? String(entry[control.iconRole] || "") : ""

                width: _row.tabWidth
                height: ListView.view.height

                Accessible.role: Accessible.PageTab
                Accessible.name: title
                Accessible.selected: checked

                ToolTip.delay: 500
                ToolTip.timeout: 5000
                ToolTip.visible: _tabMouse.containsMouse && _label.truncated
                ToolTip.text: title

                Rectangle {
                    id: _pill
                    anchors.fill: parent
                    anchors.topMargin: 3
                    anchors.bottomMargin: 3
                    radius: height / 2
                    color: _tab.checked ? LingmoUI.Theme.highlightColor
                         : _tabMouse.pressed ? LingmoUI.Theme.pressedColor
                         : _tab.hovered ? LingmoUI.Theme.hoverColor
                         : "transparent"
                    border.width: _tab.checked ? 0 : 1
                    border.color: LingmoUI.Theme.borderColor
                    scale: _tabMouse.pressed ? 0.97 : 1.0

                    Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration; easing.type: LingmoUI.Units.easing } }
                    Behavior on scale { NumberAnimation { duration: LingmoUI.Units.veryShortDuration; easing.type: LingmoUI.Units.easing } }
                }

                MouseArea {
                    id: _tabMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.MiddleButton) {
                            if (control.closable)
                                control.closeRequested(_tab.index)
                        } else {
                            control.activate(_tab.index)
                        }
                    }
                }

                readonly property color textColor: checked ? LingmoUI.Theme.highlightedTextColor
                                                  : hovered ? LingmoUI.Theme.textColor
                                                  : LingmoUI.Theme.secondaryTextColor

                RowLayout {
                    anchors.fill: _pill
                    anchors.leftMargin: LingmoUI.Units.largeSpacing
                    anchors.rightMargin: control.closable ? 3 : LingmoUI.Units.largeSpacing
                    spacing: LingmoUI.Units.smallSpacing

                    LingmoUI.IconItem {
                        visible: _tab.icon.length > 0
                        source: _tab.icon
                        Layout.preferredWidth: LingmoUI.Units.iconSizes.small
                        Layout.preferredHeight: LingmoUI.Units.iconSizes.small
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        id: _label
                        text: _tab.title
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: LingmoUI.Theme.fontFamily
                        font.pointSize: LingmoUI.Units.fontBody
                        font.weight: _tab.checked ? Font.DemiBold : Font.Normal
                        color: _tab.textColor
                        renderType: LingmoUI.Theme.renderType
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }
                    }

                    // Close: on the current tab and on the hovered one
                    Item {
                        id: _close
                        visible: control.closable
                        Layout.preferredWidth: _pill.height - 6
                        Layout.preferredHeight: _pill.height - 6
                        Layout.alignment: Qt.AlignVCenter
                        opacity: _tab.checked || _tab.hovered ? 1.0 : 0.0
                        enabled: opacity > 0

                        Accessible.role: Accessible.Button
                        Accessible.name: control.closeTipText

                        Behavior on opacity { NumberAnimation { duration: LingmoUI.Units.shortDuration } }

                        Rectangle {
                            anchors.fill: parent
                            radius: height / 2
                            color: _closeMouse.pressed ? (_tab.checked ? Qt.rgba(1, 1, 1, 0.3) : LingmoUI.Theme.pressedColor)
                                 : _closeMouse.containsMouse ? (_tab.checked ? Qt.rgba(1, 1, 1, 0.2) : LingmoUI.Theme.hoverColor)
                                 : "transparent"
                            Behavior on color { ColorAnimation { duration: LingmoUI.Units.veryShortDuration } }
                        }

                        // Drawn ×: independent of the icon theme
                        Repeater {
                            model: [45, -45]
                            Rectangle {
                                required property var modelData
                                anchors.centerIn: parent
                                width: 9; height: 1.5; radius: 0.75
                                rotation: modelData
                                color: _tab.textColor
                                antialiasing: true
                            }
                        }

                        MouseArea {
                            id: _closeMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: control.closeRequested(_tab.index)
                        }

                        ToolTip.delay: 500
                        ToolTip.visible: _closeMouse.containsMouse
                        ToolTip.text: control.closeTipText
                    }
                }
            }
        }

        LingmoUI.IconButton {
            id: _newTab
            visible: control.newTabVisible
            round: true
            tipText: control.newTabTipText
            focusPolicy: Qt.NoFocus
            Layout.alignment: Qt.AlignVCenter
            onClicked: control.newTabRequested()

            // Drawn +
            Repeater {
                model: [0, 90]
                Rectangle {
                    required property var modelData
                    parent: _newTab
                    anchors.centerIn: parent
                    width: 11; height: 1.6; radius: 0.8
                    rotation: modelData
                    color: LingmoUI.Theme.textColor
                    antialiasing: true
                }
            }
        }

        // Free space (drag the window by it when in the header strip)
        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: control.reservedWidth
        }
    }
}
