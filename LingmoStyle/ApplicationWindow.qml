// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

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
