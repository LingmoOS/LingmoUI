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

import QtQuick 2.15 as QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import LingmoUI.GraphicalEffects

import LingmoUI.CompatibleModule 3.0 as LingmoUI

QtQuick.Window {
    id: control
    width: 640
    height: 480
    visible: true
    flags: Qt.FramelessWindowHint
    color: "transparent"

    default property alias content : _content.data
    property alias background: _background
    property alias header: _header
    property alias headerBackground: _headerBackground
    property Item headerItem

    // Window helper
    property alias compositing: windowHelper.compositing
    property int contentTopMargin: _header.height
    property int windowRadius: compositing ? LingmoUI.Theme.windowRadius : 0
    property alias helper: windowHelper

    // Other
    property bool isMaximized: control.visibility === Window.Maximized
    property bool isFullScreen: control.visibility === Window.FullScreen
    property var edgeSize: windowRadius <= 0 ? 8 : windowRadius / 2

    // Resize
    property bool widthResizable: maximumWidth > minimumWidth
    property bool heightResizable: maximumHeight > minimumHeight

    property bool minimizeButtonVisible: true

    onHeaderItemChanged: {
        if (headerItem) {
            headerItem.parent = _headerContent
            headerItem.anchors.fill = _headerContent
        }
    }

    LingmoUI.WindowHelper {
        id: windowHelper
    }

    // Window shadows
    LingmoUI.WindowShadow {
        view: control
        radius: _background.radius
        strength: control.active ? 1.5 : 0.9
    }

    // Left bottom edge
    MouseArea {
        height: edgeSize * 2
        width: height
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        cursorShape: Qt.SizeBDiagCursor
        propagateComposedEvents: true
        preventStealing: false
        visible: !isMaximized && !isFullScreen
                              && control.widthResizable
                              && control.heightResizable
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) {
                                 windowHelper.startSystemResize(control, Qt.LeftEdge | Qt.BottomEdge)
                             }
        }
    }

    // Right bottom edge
    MouseArea {
        height: edgeSize * 2
        width: height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cursorShape: Qt.SizeFDiagCursor
        propagateComposedEvents: true
        preventStealing: false
        visible: !isMaximized && !isFullScreen
                              && control.widthResizable
                              && control.heightResizable
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) { windowHelper.startSystemResize(control, Qt.RightEdge | Qt.BottomEdge) }
        }
    }

    // Top edge
    MouseArea {
        height: edgeSize / 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: edgeSize * 2
        anchors.rightMargin: edgeSize * 2
        visible: !isMaximized && !isFullScreen && control.heightResizable
        cursorShape: Qt.SizeVerCursor
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) { windowHelper.startSystemResize(control, Qt.TopEdge) }
        }
    }

    // Bottom edge
    MouseArea {
        height: edgeSize / 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: edgeSize * 2
        anchors.rightMargin: edgeSize * 2
        cursorShape: Qt.SizeVerCursor
        visible: !isMaximized && !isFullScreen && control.heightResizable
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) { windowHelper.startSystemResize(control, Qt.BottomEdge) }
        }
    }

    // Left edge
    MouseArea {
        width: edgeSize / 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: edgeSize
        anchors.bottomMargin: edgeSize * 2
        cursorShape: Qt.SizeHorCursor
        visible: !isMaximized && !isFullScreen && control.widthResizable
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) { windowHelper.startSystemResize(control, Qt.LeftEdge) }
        }
    }

    // Right edge
    MouseArea {
        width: edgeSize / 2
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: edgeSize
        anchors.bottomMargin: edgeSize * 2
        cursorShape: Qt.SizeHorCursor
        visible: !isMaximized && !isFullScreen && control.widthResizable
        z: 999

        onPressed: function(mouse){ mouse.accepted = false; }

        DragHandler {
            grabPermissions: TapHandler.TakeOverForbidden
            target: null
            onActiveChanged: if (active) {
                                 windowHelper.startSystemResize(control, Qt.RightEdge)
                             }
        }
    }

    // Background
    Rectangle {
        id: _background
        anchors.fill: parent
        anchors.margins: 0
        radius: !isMaximized && !isFullScreen && windowHelper.compositing ? control.windowRadius : 0
        color: LingmoUI.Theme.backgroundColor

        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.Linear
            }
        }
    }

    // Border line
    Rectangle {
        anchors.fill: parent

        property var borderColor: compositing ? LingmoUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.3)
                                                                      : Qt.rgba(0, 0, 0, 0.2) : LingmoUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.15)
                                                                                                                      : Qt.rgba(0, 0, 0, 0.15)
        color: "transparent"
        radius: control.windowRadius
        border.color: borderColor
        border.width: 1 / Screen.devicePixelRatio
        border.pixelAligned: Screen.devicePixelRatio > 1 ? false : true
        antialiasing: true
        visible: !isMaximized && !isFullScreen
        z: 999
    }

    // Content
    Item {
        id: _contentItem
        anchors.fill: parent

        // Header
        Item {
            id: _header
            z: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 38

            property int buttonSize: 31
            property int spacing: (_header.height - _header.buttonSize) / 2

            // The strip itself takes no input: only the window buttons and the
            // headerItem's own controls do. Dragging and double clicks are
            // handled by _headerDragArea, below the content, so content placed
            // under the strip (contentTopMargin: 0) gets its clicks.
            Rectangle {
                id: _headerBackground
                anchors.fill: parent
                color: "transparent"
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Lingmo window controls on the left: close, minimize, zoom,
                // 12 px from the edge like the KWin decoration (each button is a
                // 24 px cell around a 16 px circle)
                Item {
                    Layout.preferredWidth: 8
                }

                WindowControls {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillHeight: true
                    windowActive: control.active
                    maximized: control.isMaximized
                    minimizeVisible: control.minimizeButtonVisible
                    zoomVisible: !control.isFullScreen && control.minimumWidth !== control.maximumWidth
                                 && control.maximumHeight !== control.minimumHeight
                    onCloseClicked: control.close()
                    onMinimizeClicked: windowHelper.minimizeWindow(control)
                    onZoomClicked: control.toggleMaximized()
                }

                Item {
                    id: _headerContent
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                }
            }
        }

        // Drag / double-click area of the header strip. It sits below the
        // content, so it only gets the presses nothing above it takes.
        Item {
            id: _headerDragArea
            anchors.left: _header.left
            anchors.right: _header.right
            anchors.top: _header.top
            height: _header.height
            visible: _header.visible
            enabled: _header.enabled

            TapHandler {
                enabled: !control.isFullScreen
                onTapped: if (tapCount === 2) toggleMaximized()
                gesturePolicy: TapHandler.DragThreshold
            }

            DragHandler {
                target: null
                acceptedDevices: PointerDevice.AllDevices
                grabPermissions: PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
                onActiveChanged: if (active) { windowHelper.startSystemMove(control) }
            }
        }

        // Content item.
        ColumnLayout {
            id: _contentLayout
            anchors.fill: parent
            anchors.topMargin: control.contentTopMargin
            spacing: 0

            Item {
                id: _content
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        // Mask
       layer.enabled: _background.radius > 0
       layer.effect: OpacityMask {
           maskSource: Item {
               width: _contentItem.width
               height: _contentItem.height

               Rectangle {
                   anchors.fill: parent
                   radius: _background.radius
               }
           }
       }
    }

    QtObject {
        id: internal
        property QtObject passiveNotification
    }

    function showPassiveNotification(message, timeout, actionText, callBack) {
        if (!internal.passiveNotification) {
            var component = Qt.createComponent(Qt.resolvedUrl("Toast.qml"))
            internal.passiveNotification = component.createObject(control)
        }

        internal.passiveNotification.showNotification(message, timeout, actionText, callBack)
    }

    function toggleMaximized() {
        if (isMaximized) {
            control.showNormal();
        } else {
            control.showMaximized();
        }
    }
}
