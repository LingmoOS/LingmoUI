/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Badge: a small pill with a count or a short word.

    \qml
    LingmoUI.Badge { text: "3" }                                   // accent pill
    LingmoUI.Badge { text: qsTr("New"); tone: LingmoUI.Theme.greenColor }
    LingmoUI.Badge { text: "12"; subtle: true }                     // grey, for plain counts
    LingmoUI.Badge { dot: true }                                    // 8 px dot, no text
    \endqml

    Hidden when text is empty or "0" (unless dot is set).
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
    property alias font: label.font

    visible: dot || (text.length > 0 && text !== "0")
    implicitHeight: dot ? 8 : Math.round(label.implicitHeight + 4)
    implicitWidth: dot ? 8 : Math.max(implicitHeight, Math.round(label.implicitWidth + 12))
    radius: height / 2

    color: inverted ? LingmoUI.Theme.highlightedTextColor
         : subtle ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g, LingmoUI.Theme.textColor.b,
                            LingmoUI.Theme.darkMode ? 0.16 : 0.09)
         : tone

    Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }

    Text {
        id: label
        anchors.centerIn: parent
        visible: !control.dot
        text: control.text
        font.family: LingmoUI.Theme.fontFamily
        font.pointSize: LingmoUI.Units.fontCaption
        font.weight: Font.DemiBold
        color: control.inverted ? control.tone
             : control.subtle ? LingmoUI.Theme.secondaryTextColor
             : LingmoUI.Theme.highlightedTextColor
        renderType: LingmoUI.Theme.renderType
    }
}
