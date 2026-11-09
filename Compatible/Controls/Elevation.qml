/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Effects
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Elevation: a soft drop shadow for a rounded rectangle, from the
    Theme.elevations presets. Put it behind the item it lifts:

    \qml
    LingmoUI.Elevation { anchors.fill: panel; radius: panel.radius; level: 2 }
    Rectangle { id: panel; ... }
    \endqml

    Levels: 0 flat, 1 card, 2 popup/menu, 3 window/dialog.
    Meant for opaque surfaces (the shadow is filled under the item too).
*/
RectangularShadow {
    id: control

    property int level: 1

    readonly property var preset: LingmoUI.Theme.elevations[Math.max(0, Math.min(3, level))]

    visible: level > 0
    radius: LingmoUI.Theme.mediumRadius
    blur: preset.blur
    offset: Qt.vector2d(0, preset.yOffset)
    color: Qt.rgba(0, 0, 0, preset.opacity)
    spread: 0
    cached: true

    Behavior on blur { NumberAnimation { duration: LingmoUI.Units.shortDuration } }
}
