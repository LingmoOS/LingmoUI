/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    EmptyState: what a list or page shows when it has nothing to show.

    \qml
    LingmoUI.EmptyState {
        anchors.centerIn: parent
        visible: listView.count === 0
        iconName: "mail-folder-inbox"
        title: qsTr("No messages")
        text: qsTr("New mail will appear here.")
        actionText: qsTr("Refresh")
        onActionTriggered: mail.refresh()
    }
    \endqml

    Set busy: true to show a spinner instead of the icon (first load).
    iconOpacity (0.6 light / 0.7 dark by default) and iconColor adjust the icon:
    iconOpacity: 1 for full-colour illustrations, iconColor to tint a symbolic one.
*/
Item {
    id: control

    property string iconName: ""
    property string title: ""
    property string text: ""
    // Optional button under the text
    property string actionText: ""
    property bool actionPrimary: true
    property bool busy: false
    property int iconSize: LingmoUI.Units.iconSizes.huge
    // Opacity of the icon (dimmed by default so the title leads)
    property real iconOpacity: LingmoUI.Theme.darkMode ? 0.7 : 0.6
    // Tint for monochrome (symbolic) icons; transparent = drawn as is
    property color iconColor: "transparent"

    signal actionTriggered()

    // Text wraps at this width; give it a smaller width in narrow panes
    implicitWidth: 380
    implicitHeight: column.implicitHeight

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: LingmoUI.Units.smallSpacing

        LingmoUI.Spinner {
            visible: control.busy
            running: control.busy
            size: LingmoUI.Units.iconSizes.medium
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: LingmoUI.Units.smallSpacing
        }

        LingmoUI.IconItem {
            visible: !control.busy && control.iconName.length > 0
            source: control.iconName
            color: control.iconColor
            opacity: control.iconOpacity
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: LingmoUI.Units.smallSpacing
        }

        Text {
            visible: control.title.length > 0
            text: control.title
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontSubheading
            font.weight: Font.DemiBold
            color: LingmoUI.Theme.textColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            renderType: LingmoUI.Theme.renderType
            Layout.fillWidth: true
        }

        Text {
            visible: control.text.length > 0
            text: control.text
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontBody
            color: LingmoUI.Theme.secondaryTextColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            renderType: LingmoUI.Theme.renderType
            Layout.fillWidth: true
        }

        LingmoUI.ActionButton {
            visible: control.actionText.length > 0
            text: control.actionText
            primary: control.actionPrimary
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: LingmoUI.Units.largeSpacing
            onClicked: control.actionTriggered()
        }
    }
}
