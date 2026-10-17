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
import QtQuick.Controls
import LingmoUI.GraphicalEffects
import LingmoUI.CompatibleModule as LingmoUI

Image {
    id: control
    width: 22
    height: width
    // Relative to this file: qrc:/lingmoui/kit/compatible_module/LingmoUI/CompatibleModule/images/
    // (the old "qrc:/lingmoui/kit/images/refresh.svg" no longer exists in Qt 6 builds)
    source: Qt.resolvedUrl("../images/refresh.svg")
    sourceSize: Qt.size(width, height)
    visible: true

    property alias running: rotationAnimator.running

    // Recolour the glyph to the text colour. (A ColorOverlay child using its own
    // parent as source rendered nothing on Qt 6.)
    layer.enabled: true
    layer.effect: ColorOverlay {
        color: LingmoUI.Theme.textColor
    }

    RotationAnimator {
        id: rotationAnimator
        target: control
        running: control.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 1000
    }
}
