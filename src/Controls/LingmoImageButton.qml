import QtQuick
import QtQuick.Controls
import LingmoUI

Button {
    id: control
    property string normalImage: ""
    property string hoveredImage: ""
    property string pushedImage: ""
    background: Item {
        implicitHeight: 12
        implicitWidth: 12
        BorderImage {
            anchors.fill: parent
            source: control.hovered ? (control.pressed ? control.pushedImage : control.hoveredImage) : control.normalImage
        }
    }
}
