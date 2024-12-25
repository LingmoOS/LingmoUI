/*
 * SPDX-FileCopyrightText: 2024 Elysia <elysia@lingmo.org>
 *
 * SPDX-License-Identifier: GPL-3.0
 */

import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

T.ApplicationWindow {
    id: window

    color: palette.window

    Overlay.modal: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.5)
    }

    Overlay.modeless: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.12)
    }
}
