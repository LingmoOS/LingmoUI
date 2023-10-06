import QtQuick 2.9
import QtQuick.Templates 2.2 as T
import LingmoUI 1.0 as LingmoUI

T.CheckBox {
    id: controlRoot

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                            Math.max(contentItem.implicitHeight,
                                        indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 1
    spacing: LingmoUI.Units.smallSpacing

    hoverEnabled: true

    indicator: CheckIndicator {
        control: controlRoot
    }

//    indicator: Item {
//        width: LingmoUI.Units.iconSizes.smallMedium + LingmoUI.Units.smallSpacing
//        height: LingmoUI.Units.iconSizes.smallMedium + LingmoUI.Units.smallSpacing

//        CheckIndicator {
//            anchors.centerIn: parent
//            width: LingmoUI.Units.iconSizes.smallMedium
//            height: LingmoUI.Units.iconSizes.smallMedium
//            control: controlRoot
//        }
//    }

    contentItem: Text {
        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? controlRoot.indicator.width + controlRoot.spacing : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? controlRoot.indicator.width + controlRoot.spacing : 0
        opacity: controlRoot.enabled ? 1 : 0.6
        text: controlRoot.text
        font: controlRoot.font
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: LingmoUI.Theme.textColor
    }
}
