//CuteOS - Button
import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.0
import FishUI 1.0 as FishUI
import QtQuick.Controls.impl 2.12

T.Button {
    id: control
    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + FishUI.Units.largeSpacing)
    implicitHeight: background.implicitHeight
    hoverEnabled: true

    icon.width: FishUI.Units.iconSizes.small
    icon.height: FishUI.Units.iconSizes.small

    icon.color: control.enabled ? (control.highlighted ? control.FishUI.Theme.highlightColor : control.FishUI.Theme.textColor) : control.FishUI.Theme.disabledTextColor
    spacing: FishUI.Units.smallSpacing

    property color hoveredColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.alternateBackgroundColor, 1.2)
                                                       : Qt.darker(FishUI.Theme.alternateBackgroundColor, 1.1)

    property color pressedColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.alternateBackgroundColor, 1.1)
                                                       : Qt.darker(FishUI.Theme.alternateBackgroundColor, 1.2)

    property color borderColor: Qt.rgba(FishUI.Theme.highlightColor.r,
                                        FishUI.Theme.highlightColor.g,
                                        FishUI.Theme.highlightColor.b, 0.5)

    property color flatHoveredColor: Qt.rgba(FishUI.Theme.highlightColor.r,
                                             FishUI.Theme.highlightColor.g,
                                             FishUI.Theme.highlightColor.b, 0.2)
    property color flatPressedColor: Qt.rgba(FishUI.Theme.highlightColor.r,
                                             FishUI.Theme.highlightColor.g,
                                             FishUI.Theme.highlightColor.b, 0.25)

    contentItem: IconLabel {
        text: control.text
        font: control.font
        icon: control.icon
        color: !control.enabled ? control.FishUI.Theme.disabledTextColor : control.flat ? FishUI.Theme.highlightColor : FishUI.Theme.textColor
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignCenter
    }

    background: Item {
        implicitWidth: (FishUI.Units.iconSizes.medium * 3) + FishUI.Units.largeSpacing
        implicitHeight: FishUI.Units.iconSizes.medium + FishUI.Units.smallSpacing

        Rectangle {
            id: _flatBackground
            anchors.fill: parent
            radius: FishUI.Theme.mediumRadius
            border.width: 1
            border.color: control.enabled ? control.activeFocus ? FishUI.Theme.highlightColor : "transparent"
                                          : "transparent"
            visible: control.flat

            color: {
                if (!control.enabled)
                    return FishUI.Theme.alternateBackgroundColor

                if (control.pressed)
                    return control.flatPressedColor

                if (control.hovered)
                    return control.flatHoveredColor

                return Qt.rgba(FishUI.Theme.highlightColor.r,
                               FishUI.Theme.highlightColor.g,
                               FishUI.Theme.highlightColor.b, 0.1)
            }
        }

        Rectangle {
            id: _background
            anchors.fill: parent
            radius: FishUI.Theme.mediumRadius
            border.width: 1
            visible: !control.flat
            border.color: control.enabled ? control.activeFocus ? FishUI.Theme.highlightColor : "transparent"
                                          : "transparent"

            color: {
                if (!control.enabled)
                    return FishUI.Theme.alternateBackgroundColor

                if (control.pressed)
                    return control.pressedColor

                if (control.hovered)
                    return control.hoveredColor

                return FishUI.Theme.alternateBackgroundColor
            }
        }
    }
}