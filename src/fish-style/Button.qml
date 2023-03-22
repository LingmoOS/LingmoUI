//CuteOS - Button
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI
import QtQuick.Controls.impl 2.12

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    font.pixelSize: 15
    font.weight: Font.Black

    property int radius: 20
    property color textColor: "#FFFFFF"     //Text Color
    property color lightColor: "#00B3FF"  // Start
    property color darkColor: "#56BEFF"   // End

    contentItem: Label {
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.4
        color: control.textColor
        text: control.text
    }

    background: Rectangle {
        //The background color
        id: backgroundRect
        implicitWidth: 160
        implicitHeight: 45

        radius: control.radius
        opacity: control.enabled ? 1 : 0.4
        layer.enabled: true
        layer.effect: LinearGradient {
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)  //横向
//            end: Qt.point(width, height)  //斜向
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: control.pressed ? control.darkColor : control.lightColor
                }
                GradientStop {
                    position: 1.0
                    color: control.pressed || !control.hovered ? control.darkColor : control.lightColor
                }
            }
        }
    }
}
