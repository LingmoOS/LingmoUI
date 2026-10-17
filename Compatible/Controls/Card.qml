/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Card: the grouped-content panel of Lingmo apps (Settings' RoundedItem):
    secondBackgroundColor, mediumRadius, hairline border, animated colour.

    \qml
    LingmoUI.Card {
        Layout.fillWidth: true
        implicitHeight: content.implicitHeight + LingmoUI.Units.largeSpacing * 2
        ColumnLayout { id: content; anchors.fill: parent; anchors.margins: LingmoUI.Units.largeSpacing * 1.5 }
    }

    // A list row: hover tint, clickable, lifted on hover
    LingmoUI.Card { hoverEnabled: true; clickable: true; onClicked: open(model.id) }
    \endqml

    Children are placed by you (anchors/Layout), like RoundedRect; use
    anchors.margins: card.padding for the standard inner margin.
*/
LingmoUI.RoundedRect {
    id: card

    // Hover tint (alternateBackgroundColor)
    property bool hoverEnabled: false
    // Click/press handling; emits clicked() and shows a pointing-hand cursor
    property bool clickable: false
    // Shadow level (Theme.elevations): 0 flat (default, like Settings), 1 card, 2 popup, 3 window
    property int elevation: 0
    // Raise the elevation by one while hovered (needs hoverEnabled or clickable)
    property bool liftOnHover: false
    // Suggested inner margin for the content
    property real padding: LingmoUI.Units.largeSpacing * 1.5
    // Draw with the accent tint (selected card)
    property bool highlighted: false

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    signal clicked()
    signal doubleClicked()

    radius: LingmoUI.Theme.mediumRadius
    color: {
        if (highlighted)
            return Qt.rgba(LingmoUI.Theme.highlightColor.r, LingmoUI.Theme.highlightColor.g,
                           LingmoUI.Theme.highlightColor.b, LingmoUI.Theme.darkMode ? 0.28 : 0.14)
        if (clickable && pressed)
            return Qt.darker(LingmoUI.Theme.alternateBackgroundColor, LingmoUI.Theme.darkMode ? 0.9 : 1.04)
        if ((hoverEnabled || clickable) && hovered)
            return LingmoUI.Theme.alternateBackgroundColor
        return LingmoUI.Theme.secondBackgroundColor
    }

    Accessible.role: clickable ? Accessible.Button : Accessible.Grouping

    LingmoUI.Elevation {
        z: -1
        anchors.fill: parent
        radius: card.radius
        level: card.elevation + (card.liftOnHover && card.hovered ? 1 : 0)
    }

    HoverHandler {
        id: hoverHandler
        enabled: card.hoverEnabled || card.clickable
        cursorShape: card.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        id: tapHandler
        enabled: card.clickable
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: (eventPoint, button) => {
            if (tapCount === 2)
                card.doubleClicked()
            else
                card.clicked()
        }
    }
}
