import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("LingmoUI Example")

    Button {
        id: button
        anchors.centerIn: parent
        text: "About Qt" // 按钮文本

        onClicked: {aboutQtController.showAboutQtDialog();}
    }
}
