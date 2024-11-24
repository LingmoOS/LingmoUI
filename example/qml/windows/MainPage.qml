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

    showDark: true

    LingmoLoadingButton {
        id: button
        anchors.centerIn: parent
        text: "About Qt" // 按钮文本
        disabled: false
        loading: true

        onClicked: {
            button.loading = false;
            // aboutQtController.showAboutQtDialog();
        }
    }
}
