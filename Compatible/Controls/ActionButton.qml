/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import LingmoUI.CompatibleModule as LingmoUI

/*!
    ActionButton: the rounded push button of Lingmo apps.

    \qml
    LingmoUI.ActionButton { text: qsTr("Cancel") }                             // normal
    LingmoUI.ActionButton { text: qsTr("Install"); primary: true }             // accent colour
    LingmoUI.ActionButton { text: qsTr("Delete"); destructive: true }          // red, filled
    LingmoUI.ActionButton { text: qsTr("Remove"); destructive: true; subtle: true } // red text on a red tint
    LingmoUI.ActionButton { text: qsTr("Refresh"); iconName: "view-refresh" }
    LingmoUI.ActionButton { text: qsTr("Saving…"); primary: true; busy: true } // spinner, clicks ignored
    LingmoUI.ActionButton { text: qsTr("Skip"); flat: true }                   // no resting background (quiet)
    LingmoUI.ActionButton { text: qsTr("Get"); light: true }                   // white with dark text, on banners/artwork
    \endqml
*/
T.Button {
    id: control

    property bool primary: false
    property bool destructive: false
    // destructive only: red text on a light red tint instead of a filled red button
    property bool subtle: false
    // flat (Button's own property): no background until hovered/pressed, for
    // low-key actions ("Skip", "Later"). Works with primary/destructive too
    // (accent/red text). quiet is the same.
    property alias quiet: control.flat
    // White button with dark text in both themes, for coloured banners and
    // artwork (Theme.lightBackgroundColor / lightTextColor)
    property bool light: false
    // Theme icon name (or url) shown before the text
    property string iconName: ""
    // Shows a spinner instead of the icon and ignores clicks
    property bool busy: false
    property string tipText: ""

    readonly property bool filled: !flat && !light && (primary || (destructive && !subtle))
    readonly property color baseColor: {
        if (flat)
            return "transparent"
        if (light)
            return LingmoUI.Theme.lightBackgroundColor
        if (destructive && subtle)
            return Qt.rgba(LingmoUI.Theme.redColor.r, LingmoUI.Theme.redColor.g, LingmoUI.Theme.redColor.b,
                           LingmoUI.Theme.darkMode ? 0.22 : 0.12)
        if (destructive)
            return LingmoUI.Theme.redColor
        if (primary)
            return LingmoUI.Theme.highlightColor
        return LingmoUI.Theme.alternateBackgroundColor
    }
    readonly property color foregroundColor: light ? LingmoUI.Theme.lightTextColor
                                           : filled ? LingmoUI.Theme.highlightedTextColor
                                           : destructive ? LingmoUI.Theme.redColor
                                           : flat && primary ? LingmoUI.Theme.highlightColor
                                           : LingmoUI.Theme.textColor

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    leftPadding: LingmoUI.Units.largeSpacing * 1.5
    rightPadding: LingmoUI.Units.largeSpacing * 1.5
    topPadding: LingmoUI.Units.smallSpacing
    bottomPadding: LingmoUI.Units.smallSpacing
    spacing: LingmoUI.Units.smallSpacing
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    font.family: LingmoUI.Theme.fontFamily
    font.pointSize: LingmoUI.Units.fontBody
    font.weight: primary || light ? Font.DemiBold : Font.Normal

    Accessible.role: Accessible.Button
    Accessible.name: text

    ToolTip.visible: hovered && tipText.length > 0
    ToolTip.text: tipText
    ToolTip.delay: 500

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: Math.max(row.implicitHeight, LingmoUI.Units.iconSizes.small)

        RowLayout {
            id: row
            anchors.centerIn: parent
            width: Math.min(implicitWidth, parent.width)
            spacing: control.spacing

            LingmoUI.Spinner {
                visible: control.busy
                running: control.busy
                size: LingmoUI.Units.iconSizes.small
                color: control.foregroundColor
                trackVisible: false
                Layout.alignment: Qt.AlignVCenter
            }

            LingmoUI.IconItem {
                visible: !control.busy && control.iconName.length > 0
                source: control.iconName
                Layout.preferredWidth: LingmoUI.Units.iconSizes.small
                Layout.preferredHeight: LingmoUI.Units.iconSizes.small
                Layout.alignment: Qt.AlignVCenter
                smooth: true
            }

            Text {
                visible: control.text.length > 0
                text: control.text
                font: control.font
                color: control.foregroundColor
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: LingmoUI.Theme.renderType
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    background: Rectangle {
        implicitHeight: LingmoUI.Units.controlHeight
        implicitWidth: LingmoUI.Units.controlHeight * 2
        radius: LingmoUI.Theme.smallRadius
        color: {
            const base = control.baseColor
            if (control.busy)
                return base
            if (control.flat)
                return control.down ? LingmoUI.Theme.pressedColor
                     : control.hovered ? LingmoUI.Theme.hoverColor : base
            if (control.light)
                return control.down ? Qt.darker(base, 1.12) : control.hovered ? Qt.darker(base, 1.05) : base
            if (control.down)
                return Qt.darker(base, 1.15)
            if (control.hovered)
                return control.filled ? Qt.lighter(base, 1.1)
                                      : Qt.darker(base, LingmoUI.Theme.darkMode ? 0.85 : 1.05)
            return base
        }
        border.width: control.filled || control.flat || control.light ? 0 : 1
        border.color: LingmoUI.Theme.dividerColor

        Behavior on color { ColorAnimation { duration: LingmoUI.Units.veryShortDuration } }

        // Keyboard focus ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 3
            color: "transparent"
            border.width: 2
            border.color: Qt.rgba(LingmoUI.Theme.highlightColor.r, LingmoUI.Theme.highlightColor.g,
                                  LingmoUI.Theme.highlightColor.b, 0.5)
            visible: control.visualFocus
        }
    }

    // Swallow clicks while busy without greying the button out
    MouseArea {
        anchors.fill: parent
        enabled: control.busy
        visible: control.busy
        hoverEnabled: true
        cursorShape: Qt.BusyCursor
    }
}
