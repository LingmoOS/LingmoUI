import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI

LingmoObject {
    id: root
    Component.onCompleted: {
        LingmoApp.init(root, Qt.locale("zh_CN"));
        LingmoApp.windowIcon = "qrc:/image/logo.svg"
        LingmoTheme.animationEnabled = true;
        LingmoTheme.blurBehindWindowEnabled = true;
        LingmoTheme.darkMode = LingmoThemeType.Dark;

        LingmoRouter.routes = {
            "/": "qrc:/qml/windows/MainPage.qml"
        };

        LingmoRouter.navigate("/");
    }
}
