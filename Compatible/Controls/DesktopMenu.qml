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
 
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import LingmoUI.CompatibleModule as LingmoUI

LingmoUI.MenuPopupWindow {
    id: control

    default property alias content : _mainLayout.data

    // Glass (Settings > Appearance > Glass); the menu window gets KWin's blur
    LingmoUI.GlassSurface {
        id: _background
        anchors.fill: parent
        radius: LingmoUI.Theme.glassEnabled ? LingmoUI.Theme.hugeRadius : (LingmoUI.Theme.compositing ? LingmoUI.Theme.hugeRadius : 0)
        sheenEnabled: false
        tint: LingmoUI.Theme.glassEnabled ? LingmoUI.Theme.glassTint : LingmoUI.Theme.secondBackgroundColor

        LingmoUI.WindowShadow {
            view: control
            geometry: Qt.rect(control.x, control.y, control.width, control.height)
            radius: _background.radius
        }
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.margins: 5
        spacing: 1
    }

    function open() {
        control.show()
    }

    function popup() {
        control.show()
    }
}
