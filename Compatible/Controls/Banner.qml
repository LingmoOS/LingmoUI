/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI.CompatibleModule as LingmoUI

/*!
    Banner: an inline message above content.

    \qml
    LingmoUI.Banner { type: LingmoUI.Banner.Error; text: lastError; onClosed: lastError = "" }
    LingmoUI.Banner {
        type: LingmoUI.Banner.Warning
        title: qsTr("Battery low")
        text: qsTr("Connect the charger to keep the update running.")
        closable: false
        LingmoUI.ActionButton { text: qsTr("Details") }   // optional actions on the right
    }
    \endqml

    Hidden while text and title are empty. closed() is emitted by the close
    button; clear the text (or set visible: false) in the handler.
*/
Rectangle {
    id: control

    // Use as LingmoUI.Banner.Info etc. (values 0..3; compared as numbers below
    // because a component cannot reach its own enum through the module import)
    enum Type { Info, Success, Warning, Error }

    property int type: 0
    property string title: ""
    property string text: ""
    property bool closable: true
    // Theme icon; empty uses a default per type
    property string iconName: ""
    // Extra items (buttons) on the right
    default property alias actions: actionsRow.data

    signal closed()

    readonly property color tone: type === 3 ? LingmoUI.Theme.errorColor
                                : type === 2 ? LingmoUI.Theme.warningColor
                                : type === 1 ? LingmoUI.Theme.successColor
                                : LingmoUI.Theme.infoColor

    visible: text.length > 0 || title.length > 0
    implicitWidth: row.implicitWidth + LingmoUI.Units.largeSpacing * 2
    implicitHeight: row.implicitHeight + LingmoUI.Units.largeSpacing * 1.5
    radius: LingmoUI.Theme.smallRadius
    color: Qt.rgba(tone.r, tone.g, tone.b, LingmoUI.Theme.darkMode ? 0.20 : 0.11)
    border.width: 1
    border.color: Qt.rgba(tone.r, tone.g, tone.b, LingmoUI.Theme.darkMode ? 0.45 : 0.35)

    Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title.length > 0 ? title + ". " + text : text

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: LingmoUI.Units.largeSpacing
        anchors.rightMargin: LingmoUI.Units.smallSpacing * 1.5
        anchors.topMargin: LingmoUI.Units.smallSpacing
        anchors.bottomMargin: LingmoUI.Units.smallSpacing
        spacing: LingmoUI.Units.largeSpacing

        // Type marker: a filled circle with a glyph
        Rectangle {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: control.title.length > 0 ? Qt.AlignTop : Qt.AlignVCenter
            Layout.topMargin: control.title.length > 0 ? 1 : 0
            radius: 10
            color: control.tone
            visible: control.iconName.length === 0

            Text {
                anchors.centerIn: parent
                text: control.type === 3 ? "!"
                    : control.type === 2 ? "!"
                    : control.type === 1 ? "✓" : "i"
                color: "white"
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontCaption
                font.bold: true
            }
        }

        LingmoUI.IconItem {
            visible: control.iconName.length > 0
            source: control.iconName
            Layout.preferredWidth: LingmoUI.Units.iconSizes.smallMedium
            Layout.preferredHeight: LingmoUI.Units.iconSizes.smallMedium
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                Layout.fillWidth: true
                visible: control.title.length > 0
                text: control.title
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontBody
                font.weight: Font.DemiBold
                color: LingmoUI.Theme.textColor
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
                renderType: LingmoUI.Theme.renderType
            }

            Text {
                Layout.fillWidth: true
                visible: control.text.length > 0
                text: control.text
                font.family: LingmoUI.Theme.fontFamily
                font.pointSize: LingmoUI.Units.fontBody
                color: LingmoUI.Theme.textColor
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
                renderType: LingmoUI.Theme.renderType
            }
        }

        Row {
            id: actionsRow
            Layout.alignment: Qt.AlignVCenter
            spacing: LingmoUI.Units.smallSpacing
            visible: children.length > 0
        }

        LingmoUI.IconButton {
            visible: control.closable
            Layout.alignment: control.title.length > 0 ? Qt.AlignTop : Qt.AlignVCenter
            size: 24
            round: true
            tipText: qsTr("Close")
            onClicked: control.closed()

            // Drawn cross: no dependency on the icon theme
            Item {
                anchors.centerIn: parent
                width: 10
                height: 10
                Repeater {
                    model: [45, -45]
                    Rectangle {
                        required property int modelData
                        anchors.centerIn: parent
                        width: 12
                        height: 1.6
                        radius: 0.8
                        rotation: modelData
                        color: LingmoUI.Theme.textColor
                        opacity: 0.75
                    }
                }
            }
        }
    }
}
