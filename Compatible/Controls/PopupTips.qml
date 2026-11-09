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

import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import LingmoUI.CompatibleModule as LingmoUI

Window {
    id: control
    visible: false
    color: "transparent"

    property string popupText
    property point position: Qt.point(0, 0)
    property alias backgroundOpacity: _background.tintOpacity
    property alias backgroundColor: _background.tint
    // false: a solid tip (no glass)
    property bool blurEnabled: true
    property var borderColor: windowHelper.compositing ? LingmoUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.3)
                                                                  : Qt.rgba(0, 0, 0, 0.2) : LingmoUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.1)
                                                                                                                  : Qt.rgba(0, 0, 0, 0.05)
    flags: Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus | Qt.ToolTip
    width: label.implicitWidth + LingmoUI.Units.largeSpacing * 1.5
    height: label.implicitHeight + LingmoUI.Units.largeSpacing * 1.5

    LingmoUI.WindowHelper {
        id: windowHelper
    }

    LingmoUI.WindowShadow {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        radius: _background.radius
    }

    // Glass (Settings > Appearance > Glass); the tip window gets KWin's blur
    LingmoUI.GlassSurface {
        id: _background
        anchors.fill: parent
        radius: windowHelper.compositing ? LingmoUI.Theme.mediumRadius : 0
        solid: !control.blurEnabled
        sheenEnabled: false
        highlightVisible: false
        tint: LingmoUI.Theme.glassEnabled && control.blurEnabled ? LingmoUI.Theme.glassTint
                                                                 : LingmoUI.Theme.secondBackgroundColor
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: control.popupText
        color: LingmoUI.Theme.textColor
    }

    // Callers center the tip over their item using the width it had at that moment:
    // remember that center so a later width change (new text, font loaded) keeps it
    property real _centerX: 0
    onPositionChanged: {
        _centerX = position.x + width / 2
        adjustCorrectLocation()
    }
    onWidthChanged: if (visible || popupText) adjustCorrectLocation()

    // Screen containing a point of the virtual desktop (the tip's own Screen is
    // whatever screen the window happened to be created on)
    function screenAt(x, y) {
        var screens = Qt.application.screens
        for (var i = 0; i < screens.length; ++i) {
            var s = screens[i]
            if (x >= s.virtualX && x < s.virtualX + s.width && y >= s.virtualY && y < s.virtualY + s.height)
                return s
        }
        return screens.length > 0 ? screens[0] : null
    }

    function adjustCorrectLocation() {
        var margin = LingmoUI.Units.smallSpacing
        var posX = Math.round(_centerX - control.width / 2)
        var posY = control.position.y
        var s = screenAt(_centerX, posY)

        if (s) {
            var left = s.virtualX, top = s.virtualY
            var right = left + s.width, bottom = top + s.height

            posX = Math.max(left + margin, Math.min(posX, right - control.width - margin))
            posY = Math.max(top + margin, Math.min(posY, bottom - control.height - margin))
            control.screen = s
        }

        control.x = posX
        control.y = posY
    }

    function show() {
        if (control.popupText)
            control.visible = true
    }

    function hide() {
        control.visible = false
    }
}
