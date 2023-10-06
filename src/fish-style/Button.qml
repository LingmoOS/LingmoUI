// //LingmoOS - Button
// import QtQuick 2.12
// import QtQuick.Controls 2.12
// import QtQuick.Templates 2.12 as T
// import QtGraphicalEffects 1.0
// import LingmoUI 1.0 as LingmoUI
// import QtQuick.Controls.impl 2.12
import QtQuick 2.4
import QtQuick.Templates 2.4 as T
import LingmoUI 1.0 as LingmoUI
import QtQuick.Controls.impl 2.4

T.Button
{
    id: control
    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + LingmoUI.Units.largeSpacing)
    implicitHeight: background.implicitHeight
    hoverEnabled: true

    property color hoveredColor: Qt.tint(LingmoUI.Theme.textColor, Qt.rgba(LingmoUI.Theme.backgroundColor.r,
                                                                       LingmoUI.Theme.backgroundColor.g,
                                                                       LingmoUI.Theme.backgroundColor.b, 0.9))
    property color pressedColor: Qt.tint(LingmoUI.Theme.textColor, Qt.rgba(LingmoUI.Theme.backgroundColor.r,
                                                                       LingmoUI.Theme.backgroundColor.g,
                                                                       LingmoUI.Theme.backgroundColor.b, 0.8))

    property color flatHoveredColor: Qt.lighter(LingmoUI.Theme.highlightColor, 1.1)
    property color flatPressedColor: Qt.darker(LingmoUI.Theme.highlightColor, 1.1)

    icon.width: LingmoUI.Units.iconSizes.small
    icon.height: LingmoUI.Units.iconSizes.small

    icon.color: control.enabled ? (control.highlighted ? control.LingmoUI.Theme.highlightColor : control.LingmoUI.Theme.textColor) : control.LingmoUI.Theme.disabledTextColor
    spacing: LingmoUI.Units.smallSpacing

    contentItem: IconLabel {
        text: control.text
        font: control.font
        icon: control.icon
        color: !control.enabled ? control.LingmoUI.Theme.disabledTextColor : control.flat ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignCenter
    }

    background: Item {
        implicitWidth:  (LingmoUI.Units.iconSizes.medium * 3) + LingmoUI.Units.largeSpacing
        implicitHeight: LingmoUI.Units.iconSizes.medium + LingmoUI.Units.smallSpacing

        Rectangle {
            id: _border
            anchors.fill: parent
            radius: LingmoUI.Theme.mediumRadius
            border.width: 1
            border.color: control.flat && control.enabled ? LingmoUI.Theme.highlightColor : control.activeFocus || control.pressed ? LingmoUI.Theme.highlightColor : 
                          Qt.tint(LingmoUI.Theme.textColor, Qt.rgba(LingmoUI.Theme.backgroundColor.r, LingmoUI.Theme.backgroundColor.g, LingmoUI.Theme.backgroundColor.b, 0.7))
            color: control.flat && control.enabled ? control.pressed ? control.flatPressedColor : control.hovered ? control.flatHoveredColor : LingmoUI.Theme.highlightColor
                                                   : control.pressed ? control.pressedColor : control.hovered ? control.hoveredColor : LingmoUI.Theme.backgroundColor
        }
    }
}
// T.Button {
//     id: control
//     implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + LingmoUI.Units.largeSpacing)
//     implicitHeight: background.implicitHeight
//     hoverEnabled: true

//     icon.width: LingmoUI.Units.iconSizes.small
//     icon.height: LingmoUI.Units.iconSizes.small

//     icon.color: control.enabled ? (control.highlighted ? control.LingmoUI.Theme.highlightColor : control.LingmoUI.Theme.textColor) : control.LingmoUI.Theme.disabledTextColor
//     spacing: LingmoUI.Units.smallSpacing

//     // property color hoveredColor: LingmoUI.Theme.darkMode ? Qt.lighter(LingmoUI.Theme.alternateBackgroundColor, 1.2)
//     //                                                    : Qt.darker(LingmoUI.Theme.alternateBackgroundColor, 1.1)

//     // property color pressedColor: LingmoUI.Theme.darkMode ? Qt.lighter(LingmoUI.Theme.alternateBackgroundColor, 1.1)
//     //                                                    : Qt.darker(LingmoUI.Theme.alternateBackgroundColor, 1.2)
//     property color hoveredColor: LingmoUI.Theme.darkMode ? Qt.lighter(LingmoUI.Theme.wBoColor, 1.2)
//                                                        : Qt.darker(LingmoUI.Theme.wBoColor, 1.1)

//     property color pressedColor: LingmoUI.Theme.darkMode ? Qt.lighter(LingmoUI.Theme.wBoColor, 1.1)
//                                                        : Qt.darker(LingmoUI.Theme.wBoColor, 1.2)

//     property color borderColor: Qt.rgba(LingmoUI.Theme.highlightColor.r,
//                                         LingmoUI.Theme.highlightColor.g,
//                                         LingmoUI.Theme.highlightColor.b, 0.5)

//     property color flatHoveredColor: Qt.rgba(LingmoUI.Theme.highlightColor.r,
//                                              LingmoUI.Theme.highlightColor.g,
//                                              LingmoUI.Theme.highlightColor.b, 0.2)
//     property color flatPressedColor: Qt.rgba(LingmoUI.Theme.highlightColor.r,
//                                              LingmoUI.Theme.highlightColor.g,
//                                              LingmoUI.Theme.highlightColor.b, 0.25)

//     contentItem: IconLabel {
//         text: control.text
//         font: control.font
//         icon: control.icon
//         // color: !control.enabled ? control.LingmoUI.Theme.disabledTextColor : control.flat ? LingmoUI.Theme.highlightColor : LingmoUI.Theme.textColor
//         // color: LingmoUI.Theme.textColor
//         color: !control.flat ? control.LingmoUI.Theme.nflatBoColor : control.flat ? LingmoUI.Theme.linesColor : LingmoUI.Theme.textColor
//         spacing: control.spacing
//         mirrored: control.mirrored
//         display: control.display
//         alignment: Qt.AlignCenter
//     }

//     background: Item {
//         implicitWidth: (LingmoUI.Units.iconSizes.medium * 3) + LingmoUI.Units.largeSpacing
//         implicitHeight: LingmoUI.Units.iconSizes.medium + LingmoUI.Units.smallSpacing

//         Rectangle {
//             id: _flatBackground
//             anchors.fill: parent
//             radius: 20
//             border.width: 2
//             border.color: LingmoUI.Theme.linesColor
//             visible: control.flat

//             color: {
//                 if (!control.enabled)
//                     // return LingmoUI.Theme.alternateBackgroundColor
//                     return "transparent"

//                 if (control.pressed)
//                     return control.flatPressedColor

//                 if (control.hovered)
//                     return control.flatHoveredColor
//                     // return LingmoUI.Theme.hoColor

//                 return "transparent"
//                 // return Qt.rgba(LingmoUI.Theme.highlightColor.r,
//                 //                LingmoUI.Theme.highlightColor.g,
//                 //                LingmoUI.Theme.highlightColor.b, 0.1)
//             }
//         }

//         Rectangle {
//             id: _background
//             anchors.fill: parent
//             radius: 20
//             border.width: 2
//             visible: !control.flat
//             // border.color: control.enabled ? control.activeFocus ? LingmoUI.Theme.highlightColor : "transparent"
//             //                               : "transparent"
//             border.color: LingmoUI.Theme.nflatBoColor

//             color: {
//                 if (!control.enabled)
//                     return "transparent"

//                 if (control.pressed)
//                     return control.pressedColor

//                 if (control.hovered)
//                     return control.hoveredColor

//                 // return LingmoUI.Theme.alternateBackgroundColor
//                 return "transparent"
//             }
//         }

//         // Rectangle {
//         //     id: _background
//         //     anchors.fill: parent
//         //     radius: 20
//         //     border.width: 0
//         //     visible: !control.flat
//         //     border.color: control.enabled ? control.activeFocus ? LingmoUI.Theme.highlightColor : "transparent"
//         //                                   : "transparent"

//         //     color: {
//         //         if (!control.enabled)
//         //             return LingmoUI.Theme.alternateBackgroundColor

//         //         if (control.pressed)
//         //             return control.pressedColor

//         //         if (control.hovered)
//         //             return control.hoveredColor

//         //         return LingmoUI.Theme.alternateBackgroundColor
//         //     }
//         // }
//     }
// }