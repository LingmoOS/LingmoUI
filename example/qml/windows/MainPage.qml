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

    ColumnLayout {
        anchors.fill: parent

        LingmoLoadingButton {
            id: button
            Layout.alignment: Qt.AlignHCenter
            text: "About Qt" // 按钮文本
            disabled: false
            loading: true

            onClicked: {
                button.loading = false
                // aboutQtController.showAboutQtDialog();
            }
        }

        LingmoDropDownBox {
            text: "DropDownButton"
            Layout.alignment: Qt.AlignHCenter

            LingmoMenuItem {
                text: "Menu_1"
            }
            LingmoMenuItem {
                text: "Menu_2"
            }
            LingmoMenuItem {
                text: "Menu_3"
            }
            LingmoMenuItem {
                text: "Menu_4"
            }
        }
    }
}
