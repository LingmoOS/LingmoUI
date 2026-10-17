/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import LingmoUI.CompatibleModule as LingmoUI

/*!
    IconButton: an icon-only button with a theme icon, a tooltip and an
    animated hover/press background.

    \qml
    LingmoUI.IconButton { iconName: "view-refresh"; tipText: qsTr("Refresh"); onClicked: reload() }
    LingmoUI.IconButton { iconName: "view-list-details"; checkable: true; checked: listMode }
    LingmoUI.IconButton { iconName: "edit-delete"; size: LingmoUI.Units.iconSizes.medium; iconSize: 22 }
    \endqml

    Use theme icon names, never emoji. checked draws an accent tint.
*/
T.AbstractButton {
    id: control

    // Theme icon name, or an image url
    property string iconName: ""
    property string tipText: ""
    // Square button size and icon size
    property int size: LingmoUI.Units.smallControlHeight
    property int iconSize: LingmoUI.Units.iconSizes.small
    // Round instead of rounded-square
    property bool round: false
    // Draw a neutral background even when idle (toolbar buttons on a card)
    property bool flat: true

    implicitWidth: size
    implicitHeight: size
    hoverEnabled: true
    focusPolicy: Qt.TabFocus
    opacity: enabled ? 1.0 : 0.4

    Accessible.role: Accessible.Button
    Accessible.name: tipText.length > 0 ? tipText : text

    ToolTip.visible: hovered && tipText.length > 0
    ToolTip.text: tipText
    ToolTip.delay: 500

    background: Rectangle {
        radius: control.round ? height / 2 : LingmoUI.Theme.smallRadius
        color: {
            if (control.checked) {
                const a = control.down ? 0.32 : control.hovered ? 0.26 : 0.20
                return Qt.rgba(LingmoUI.Theme.highlightColor.r, LingmoUI.Theme.highlightColor.g,
                               LingmoUI.Theme.highlightColor.b, a)
            }
            if (control.down)
                return LingmoUI.Theme.pressedColor
            if (control.hovered)
                return LingmoUI.Theme.hoverColor
            return control.flat ? "transparent" : LingmoUI.Theme.alternateBackgroundColor
        }
        border.width: control.visualFocus ? 2 : 0
        border.color: LingmoUI.Theme.highlightColor

        Behavior on color { ColorAnimation { duration: LingmoUI.Units.veryShortDuration } }
    }

    contentItem: Item {
        LingmoUI.IconItem {
            id: icon
            anchors.centerIn: parent
            width: control.iconSize
            height: control.iconSize
            source: control.iconName
            smooth: true
            scale: control.down ? 0.88 : 1.0

            Behavior on scale {
                NumberAnimation { duration: LingmoUI.Units.veryShortDuration; easing.type: Easing.OutCubic }
            }
        }
    }
}
