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
    // implicitHeight follows the content: implicitHeight of each child plus
    // its anchors' top and bottom margins
    LingmoUI.Card {
        Layout.fillWidth: true
        ColumnLayout { anchors.fill: parent; anchors.margins: LingmoUI.Units.largeSpacing * 1.5 }
    }

    // A list row: hover tint, clickable, lifted on hover
    LingmoUI.Card { hoverEnabled: true; clickable: true; onClicked: open(model.id) }
    \endqml

    Children are placed by you (anchors/Layout), like RoundedRect; use
    anchors.margins: card.padding for the standard inner margin. The card's
    implicitHeight is computed from them (the tallest visible child's
    implicitHeight + anchors.topMargin + anchors.bottomMargin), so you don't need
    to write implicitHeight: content.implicitHeight + ...; set implicitHeight or
    height yourself to override it.
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

    // implicitHeight computed from the children (see above)
    readonly property real contentImplicitHeight: {
        let h = 0
        const items = card.children
        for (let i = 0; i < items.length; ++i) {
            const child = items[i]
            // Skip the card's own background/border/shadow items
            if (!child.visible || child.objectName.startsWith("__"))
                continue
            h = Math.max(h, child.anchors.topMargin + child.implicitHeight + child.anchors.bottomMargin)
        }
        return h
    }

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    signal clicked()
    signal doubleClicked()

    implicitHeight: contentImplicitHeight
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
        objectName: "__cardElevation"
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
