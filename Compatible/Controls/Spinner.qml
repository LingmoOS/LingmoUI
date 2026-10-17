/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Shapes
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Spinner: an indeterminate "loading" ring.

    \qml
    LingmoUI.Spinner { running: model.loading }          // 22 px, accent colour
    LingmoUI.Spinner { size: LingmoUI.Units.iconSizes.medium; color: LingmoUI.Theme.textColor }
    \endqml

    Hidden while not running (set keepVisible: true to keep the empty space).
*/
Item {
    id: control

    property bool running: true
    property int size: LingmoUI.Units.iconSizes.smallMedium
    property color color: LingmoUI.Theme.highlightColor
    // Faint full circle behind the arc
    property bool trackVisible: true
    property bool keepVisible: false
    property real lineWidth: Math.max(2, Math.round(Math.min(width, height) / 9))

    implicitWidth: size
    implicitHeight: size
    visible: running || keepVisible
    opacity: running ? 1 : 0

    Behavior on opacity { NumberAnimation { duration: LingmoUI.Units.shortDuration } }

    Shape {
        id: shape
        anchors.centerIn: parent
        width: Math.min(control.width, control.height)
        height: width
        preferredRendererType: Shape.CurveRenderer
        readonly property real r: (width - control.lineWidth) / 2

        ShapePath {
            strokeColor: control.trackVisible
                         ? Qt.rgba(control.color.r, control.color.g, control.color.b, 0.18)
                         : "transparent"
            strokeWidth: control.lineWidth
            fillColor: "transparent"
            PathAngleArc {
                centerX: shape.width / 2
                centerY: shape.height / 2
                radiusX: shape.r
                radiusY: shape.r
                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            strokeColor: control.color
            strokeWidth: control.lineWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: shape.width / 2
                centerY: shape.height / 2
                radiusX: shape.r
                radiusY: shape.r
                startAngle: -90
                sweepAngle: 100
            }
        }

        RotationAnimator on rotation {
            from: 0
            to: 360
            duration: 900
            loops: Animation.Infinite
            running: control.running && control.visible
        }
    }
}
