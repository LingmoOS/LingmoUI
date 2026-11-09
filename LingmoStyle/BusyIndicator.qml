
/*
 * SPDX-FileCopyrightText: 2024 Elysia <elysia@lingmo.org>
 *
 * SPDX-License-Identifier: GPL-3.0
 */
import QtQuick
import QtQuick.Templates as T
import LingmoUI.CompatibleModule 3.0 as LUI

// The ring is LingmoUI.CompatibleModule's Spinner. (It used LingmoProgressRing,
// which referenced an undefined `size` and bound its size to the control's
// implicit size, which in turn came from it.)
T.BusyIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2

    contentItem: LUI.Spinner {
        implicitWidth: 28
        implicitHeight: 28
        running: control.running && control.visible
        keepVisible: true
        trackVisible: true
        lineWidth: Math.min(width, height) < 40 ? 3 : 4 // "Small" vs. "Large"
    }
}
