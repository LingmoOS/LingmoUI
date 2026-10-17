/*
 * Copyright (C) 2021 LingmoOS Team.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

pragma Singleton

import QtQuick 2.4
import LingmoUI.CompatibleModule as LingmoUI

QtObject {
    id: theme

    property real devicePixelRatio: LingmoUI.ThemeManager.devicePixelRatio

    property bool darkMode: LingmoUI.ThemeManager.darkMode

    property color blueColor: LingmoUI.ThemeManager.blueColor
    property color redColor: LingmoUI.ThemeManager.redColor
    property color greenColor: LingmoUI.ThemeManager.greenColor
    property color purpleColor: LingmoUI.ThemeManager.purpleColor
    property color pinkColor: LingmoUI.ThemeManager.pinkColor
    property color orangeColor: LingmoUI.ThemeManager.orangeColor
    property color greyColor: LingmoUI.ThemeManager.greyColor

    property color backgroundColor: darkMode ? "#1C1C1D" : "#F3F4F9"
    property color secondBackgroundColor: darkMode ? "#2C2C2D" : "#FFFFFF"
    property color alternateBackgroundColor: darkMode ? "#3C3C3D" : "#F2F4F5"

    property color textColor: darkMode ? "#FFFFFF" : "#323238"
    property color disabledTextColor: darkMode ? "#888888" : "#64646E"

    property color highlightColor: LingmoUI.ThemeManager.accentColor
    property color highlightedTextColor: darkMode ? "#FFFFFF" : "#FFFFFF"

    property color activeTextColor: "#0176D3"
    property color activeBackgroundColor: "#0176D3"

    property color linkColor: "#2196F3"
    property color linkBackgroundColor: "#2196F3"
    property color visitedLinkColor: "#2196F3"
    property color visitedLinkBackgroundColor: "#2196F3"

    property real fontSize: LingmoUI.ThemeManager.fontSize
    property string fontFamily: LingmoUI.ThemeManager.fontFamily

    property real smallRadius: 8.0
    property real mediumRadius: 10.0
    property real bigRadius: 12.0
    property real hugeRadius: 14.0
    property real windowRadius: 11.0

    property var renderType: Text.QtRendering

    property font defaultFont: fontMetrics.font
    property font smallFont: {
        let font = fontMetrics.font
        if (!!font.pixelSize) {
            font.pixelSize =- 2
        } else {
            font.pointSize =- 2
        }
        return font
    }

    // ------------------------------------------------------------------
    // Design tokens (added in 3.1; see docs/ui-guidelines.md)
    // ------------------------------------------------------------------

    // Secondary text (subtitles, hints, captions). Unlike disabledTextColor it
    // passes WCAG AA (>= 4.5:1) on backgroundColor, secondBackgroundColor and
    // alternateBackgroundColor in both themes.
    property color secondaryTextColor: darkMode ? "#AEAEB2" : "#55555F"

    // Neutral surfaces
    property color sideBarColor: darkMode ? Qt.rgba(0.11, 0.11, 0.15, 0.55) : "#EDEEF2"
    property color borderColor: darkMode ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.10)
    property color dividerColor: darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
    property color hoverColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.08)
    property color pressedColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.15)

    // Semantic colours
    property color infoColor: highlightColor
    property color successColor: greenColor
    property color warningColor: orangeColor
    property color errorColor: redColor

    property real tinyRadius: 4.0

    // Always-light tokens: the same in both themes.
    // Light surfaces that stay light in dark mode (white buttons on coloured
    // banners and artwork)
    readonly property color lightBackgroundColor: "#FFFFFF"
    readonly property color lightAlternateBackgroundColor: "#F2F4F5"
    readonly property color lightTextColor: "#1D1D22"
    readonly property color lightSecondaryTextColor: "#55555F"
    // Over photos and video (viewer chrome, captions, controls on a picture):
    // white text on a dark translucent backdrop
    readonly property color overlayTextColor: "#FFFFFF"
    readonly property color overlaySecondaryTextColor: Qt.rgba(1, 1, 1, 0.78)
    readonly property color overlayBackgroundColor: Qt.rgba(0, 0, 0, 0.55)
    readonly property color overlayScrimColor: Qt.rgba(0, 0, 0, 0.35)
    readonly property color overlayHoverColor: Qt.rgba(1, 1, 1, 0.14)
    readonly property color overlayPressedColor: Qt.rgba(1, 1, 1, 0.24)
    readonly property color overlayBorderColor: Qt.rgba(1, 1, 1, 0.18)

    // Elevation presets for Elevation / Card (index = level).
    //   0 flat, 1 card, 2 popup/menu, 3 window/dialog
    // blur and yOffset in px, opacity of the black shadow.
    property color shadowColor: "#000000"
    readonly property var elevations: [
        { blur: 0, yOffset: 0, opacity: 0.0 },
        { blur: 8, yOffset: 1, opacity: darkMode ? 0.30 : 0.07 },
        { blur: 18, yOffset: 4, opacity: darkMode ? 0.45 : 0.14 },
        { blur: 32, yOffset: 8, opacity: darkMode ? 0.55 : 0.20 }
    ]

    property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
    ]
}
