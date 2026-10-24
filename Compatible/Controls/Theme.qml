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

    // ------------------------------------------------------------------
    // "Vidro Lingmo": one glass material for the whole shell (3.2).
    // Settings > Appearance > Glass: Strong / Balanced / Weak / Off.
    // GlassSurface draws it; read these tokens for anything custom.
    // ------------------------------------------------------------------

    readonly property int glassOff: 0
    readonly property int glassWeak: 1
    readonly property int glassBalanced: 2
    readonly property int glassStrong: 3

    // The user's level (0 off .. 3 strong)
    readonly property int glassLevel: LingmoUI.ThemeManager.glassLevel
    // Whether a compositor is running (no blur or translucency without one)
    readonly property bool compositing: LingmoUI.ThemeManager.compositing
    // Glass actually drawn: a level is chosen and there is a compositor.
    // false = solid surfaces (Off, or KWin compositing disabled)
    readonly property bool glassEnabled: glassLevel > glassOff && compositing
    // Effective level: 0 whenever glass falls back to solid
    readonly property int glassEffectiveLevel: glassEnabled ? glassLevel : glassOff

    // Accessibility: fewer and shorter animations, no springs, no light sheen
    readonly property bool reduceMotion: LingmoUI.ThemeManager.reduceMotion

    // Base colour under the glass: the window background with a breath of the
    // accent colour at the stronger levels (Lingmo's own tint, not grey)
    readonly property color glassTint: Qt.tint(backgroundColor,
                                               Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b,
                                                       [0, 0.0, 0.025, 0.045][glassEffectiveLevel]))
    // How opaque the tint is over the blurred background (1 = solid)
    readonly property real glassOpacity: darkMode ? [1.0, 0.86, 0.72, 0.56][glassEffectiveLevel]
                                                  : [1.0, 0.88, 0.76, 0.60][glassEffectiveLevel]
    // glassTint with glassOpacity applied
    readonly property color glassColor: Qt.rgba(glassTint.r, glassTint.g, glassTint.b, glassOpacity)
    // Raised areas on glass (cards, tiles, the Island's controls)
    readonly property color glassRaisedColor: darkMode ? Qt.rgba(1, 1, 1, [0.06, 0.07, 0.08, 0.09][glassEffectiveLevel])
                                                       : Qt.rgba(1, 1, 1, [0.70, 0.55, 0.45, 0.38][glassEffectiveLevel])
    // Background blur in px for the level. KWin's blur is global: lingmo-core
    // maps the level to KWin's BlurStrength (7 / 11 / 15); in-app blurs
    // (MultiEffect over the app's own content) can use this value directly
    readonly property int glassBlurRadius: [0, 12, 20, 32][glassEffectiveLevel]
    // Hairline around the surface
    readonly property color glassBorderColor: darkMode ? Qt.rgba(1, 1, 1, [0.10, 0.12, 0.14, 0.16][glassEffectiveLevel])
                                                       : Qt.rgba(0, 0, 0, [0.12, 0.10, 0.09, 0.08][glassEffectiveLevel])
    // 1 px inner light along the top and left edges (light from above)
    readonly property color glassHighlight: darkMode ? Qt.rgba(1, 1, 1, [0.0, 0.08, 0.12, 0.18][glassEffectiveLevel])
                                                     : Qt.rgba(1, 1, 1, [0.0, 0.50, 0.65, 0.85][glassEffectiveLevel])
    // Grain over the tint (a tiled texture, drawn once)
    readonly property real glassNoiseOpacity: [0, 0.018, 0.028, 0.04][glassEffectiveLevel] * (darkMode ? 1.4 : 1.0)
    // Soft elevation: { blur, yOffset, opacity } like elevations[]
    readonly property var glassElevation: ({
        blur: [18, 14, 20, 28][glassEffectiveLevel],
        yOffset: [4, 3, 5, 8][glassEffectiveLevel],
        opacity: darkMode ? [0.45, 0.32, 0.40, 0.48][glassEffectiveLevel]
                          : [0.14, 0.08, 0.11, 0.14][glassEffectiveLevel]
    })
    // Pointer-following light on glass panels: Strong only, never with reduce motion
    readonly property bool glassSheen: glassEffectiveLevel === glassStrong && !reduceMotion
    readonly property color glassSheenColor: Qt.rgba(1, 1, 1, darkMode ? 0.10 : 0.35)

    property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
    ]
}
