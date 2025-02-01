import QtQuick
import LingmoUI

LingmoObject {
    property var navigationView
    property var paneItemMenu

    function rename(item, newName) {
        if (newName && newName.trim().length > 0) {
            item.title = newName;
        }
    }

    LingmoPanelItem {
        id: home_page
        count: 0
        title: qsTr("Home")
        menuDelegate: paneItemMenu
        infoBadge: LingmoBadge{
            count: home_page.count
        }
        icon: LingmoIcons.Home
        url: "qrc:/qml/pages/Buttons.qml"
        onTap: {
            if(navigationView.getCurrentUrl()){
                home_page.count = 0
            }
            navigationView.push(url)
        }
    }

    LingmoPanelItem {
        id: tab_view
        count: 0
        title: qsTr("Tab View")
        menuDelegate: paneItemMenu
        infoBadge: LingmoBadge{
            count: tab_view.count
        }
        icon: LingmoIcons.TaskView
        url: "qrc:/qml/pages/TabView.qml"
        onTap: {
            if(navigationView.getCurrentUrl()){
                tab_view.count = 0
            }
            navigationView.push(url)
        }
    }
}
