import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI

LingmoWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("LingmoUI Example")

    LingmoTextButton {
        id: button
        anchors.centerIn: parent
        text: "About Qt" // 按钮文本

        onClicked: {aboutQtController.showAboutQtDialog();}
    }
}
