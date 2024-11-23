import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import LingmoUI

Rectangle {
    property string title: ""
    property string darkText: qsTr("Dark")
    property string lightText: qsTr("Light")
    property string minimizeText: qsTr("Minimize")
    property string restoreText: qsTr("Restore")
    property string maximizeText: qsTr("Maximize")
    property string closeText: qsTr("Close")
    property string stayTopText: qsTr("Sticky on Top")
    property string stayTopCancelText: qsTr("Cancel Sticky on Top")

    property color textColor: LingmoTheme.fontPrimaryColor
    property color minimizeNormalColor: LingmoTheme.itemNormalColor
    property color minimizeHoverColor: LingmoTheme.itemHoverColor
    property color minimizePressColor: LingmoTheme.itemPressColor
    property color maximizeNormalColor: LingmoTheme.itemNormalColor
    property color maximizeHoverColor: LingmoTheme.itemHoverColor
    property color maximizePressColor: LingmoTheme.itemPressColor
    property color closeNormalColor: Qt.rgba(0, 0, 0, 0)
    property color closeHoverColor: Qt.rgba(251 / 255, 115 / 255, 115 / 255, 1)
    property color closePressColor: Qt.rgba(251 / 255, 115 / 255,
                                            115 / 255, 0.8)

    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property bool titleVisible: true
    property url icon
    property int iconSize: 20
    property bool isMac: LingmoTools.isMacos(
                             ) // May be used in future for multi-platform
    property color borerlessColor: LingmoTheme.primaryColor
    property alias buttonStayTop: btn_stay_top
    property alias buttonMinimize: btn_minimize
    property alias buttonMaximize: btn_maximize
    property alias buttonClose: btn_close
    property alias buttonDark: btn_dark
    property alias layoutMacosButtons: layout_macos_buttons
    property alias layoutStandardbuttons: layout_standard_buttons

    // Some helpers
    property var maxClickListener: function () {
        if (LingmoTools.isMacos()) {
            if (d.win.visibility === Window.FullScreen
                    || d.win.visibility === Window.Maximized)
                d.win.showNormal()
            else
                d.win.showFullScreen()
        } else {
            if (d.win.visibility === Window.Maximized
                    || d.win.visibility === Window.FullScreen)
                d.win.showNormal()
            else
                d.win.showMaximized()
            d.hoverMaxBtn = false
        }
    }
    property var minClickListener: function () {
        if (d.win.transientParent != null) {
            d.win.transientParent.showMinimized()
        } else {
            d.win.showMinimized()
        }
    }
    property var closeClickListener: function () {
        d.win.close()
    }
    property var stayTopClickListener: function () {
        if (d.win instanceof LingmoWindow) {
            d.win.stayTop = !d.win.stayTop
        }
    }
    property var darkClickListener: function () {
        if (LingmoTheme.dark) {
            LingmoTheme.darkMode = LingmoThemeType.Light
        } else {
            LingmoTheme.darkMode = LingmoThemeType.Dark
        }
    }

    id: control
    color: Qt.rgba(0, 0, 0, 0)
    height: visible ? 30 : 0
    opacity: visible
    z: 65535

    Item {
        id: d
        property var hitTestList: []
        property bool hoverMaxBtn: false
        property var win: Window.window
        property bool stayTop: {
            if (d.win instanceof FluWindow) {
                return d.win.stayTop
            }
            return false
        }
        property bool isRestore: win
                                 && (Window.Maximized === win.visibility
                                     || Window.FullScreen === win.visibility)
        property bool resizable: win && !(win.height === win.maximumHeight
                                          && win.height === win.minimumHeight
                                          && win.width === win.maximumWidth
                                          && win.width === win.minimumWidth)
        function containsPointToItem(point, item) {
            var pos = item.mapToGlobal(0, 0)
            var rect = Qt.rect(pos.x, pos.y, item.width, item.height)
            if (point.x > rect.x && point.x < (rect.x + rect.width)
                    && point.y > rect.y && point.y < (rect.y + rect.height)) {
                return true
            }
            return false
        }
    }

    // A menubar for macOS
    Component {
        id: com_macos_buttons
        RowLayout {
            LingmoImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_close_normal.png"
                hoveredImage: "../Image/btn_close_hovered.png"
                pushedImage: "../Image/btn_close_pushed.png"
                visible: showClose
                onClicked: closeClickListener()
            }
            LingmoImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_min_normal.png"
                hoveredImage: "../Image/btn_min_hovered.png"
                pushedImage: "../Image/btn_min_pushed.png"
                onClicked: minClickListener()
                visible: showMinimize
            }
            LingmoImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_max_normal.png"
                hoveredImage: "../Image/btn_max_hovered.png"
                pushedImage: "../Image/btn_max_pushed.png"
                onClicked: maxClickListener()
                visible: d.resizable && showMaximize
            }
        }
    }

    // ***************
    // * Real Layout *
    // ***************


}
