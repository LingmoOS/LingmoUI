/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Badge: a small pill with a count or a short word.

    \qml
    LingmoUI.Badge { text: "3" }                                   // accent pill
    LingmoUI.Badge { text: qsTr("New"); tone: LingmoUI.Theme.greenColor }
    LingmoUI.Badge { text: "12"; subtle: true }                     // grey, for plain counts
    LingmoUI.Badge { dot: true }                                    // 8 px dot, no text
    // Tinted: light wash of the colour with text in the colour (status chips)
    LingmoUI.Badge { text: qsTr("Verified"); tint: LingmoUI.Theme.greenColor; iconName: "security-high-symbolic" }
    \endqml

    Hidden when text is empty or "0" and there is no icon (unless dot is set).
    The icon is tinted with the text colour, so use monochrome (symbolic) icons.
*/
Rectangle {
    id: control

    property string text: ""
    // Background tone; the text is white on it
    property color tone: LingmoUI.Theme.highlightColor
    // Neutral grey pill with normal text colour (counters in lists)
    property bool subtle: false
    // Just a dot (unread marker)
    property bool dot: false
    // On a selected (highlighted) row: white pill with accent text
    property bool inverted: false
    // Tinted pill: a light wash of this colour with text and icon in it
    // (transparent = off)
    property color tint: "transparent"
    // Theme icon name (or url) before the text
    property string iconName: ""
    property int iconSize: LingmoUI.Units.iconSizes.small - 4
    property alias font: label.font

    readonly property bool tinted: tint.a > 0
    readonly property color textColor: inverted ? tone
                                     : tinted ? tint
                                     : subtle ? LingmoUI.Theme.secondaryTextColor
                                     : LingmoUI.Theme.highlightedTextColor
    readonly property bool hasText: text.length > 0 && text !== "0"

    visible: dot || hasText || iconName.length > 0
    implicitHeight: dot ? 8 : Math.round(Math.max(label.implicitHeight, iconSize) + 4)
    implicitWidth: dot ? 8 : Math.max(implicitHeight, Math.round(row.implicitWidth + (hasText ? 12 : 8)))
    radius: height / 2

    color: inverted ? LingmoUI.Theme.highlightedTextColor
         : tinted ? Qt.rgba(tint.r, tint.g, tint.b, LingmoUI.Theme.darkMode ? 0.22 : 0.14)
         : subtle ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g, LingmoUI.Theme.textColor.b,
                            LingmoUI.Theme.darkMode ? 0.16 : 0.09)
         : tone

    Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }

    RowLayout {
        id: row
        anchors.centerIn: parent
        visible: !control.dot
        spacing: 3

        LingmoUI.IconItem {
            visible: control.iconName.length > 0
            source: control.iconName
            color: control.textColor
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: label
            visible: control.hasText
            text: control.text
            font.family: LingmoUI.Theme.fontFamily
            font.pointSize: LingmoUI.Units.fontCaption
            font.weight: Font.DemiBold
            color: control.textColor
            renderType: LingmoUI.Theme.renderType
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
