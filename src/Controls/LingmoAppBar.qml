import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import LingmoUI

Rectangle {
    property string title: ""
    property string darkText : qsTr("Dark")
    property string lightText : qsTr("Light")
    property string minimizeText : qsTr("Minimize")
    property string restoreText : qsTr("Restore")
    property string maximizeText : qsTr("Maximize")
    property string closeText : qsTr("Close")
    property string stayTopText : qsTr("Sticky on Top")
    property string stayTopCancelText : qsTr("Cancel Sticky on Top")

    property color textColor: LingmoTh
    property color minimizeNormalColor: FluTheme.itemNormalColor
    property color minimizeHoverColor: FluTheme.itemHoverColor
    property color minimizePressColor: FluTheme.itemPressColor
    property color maximizeNormalColor: FluTheme.itemNormalColor
    property color maximizeHoverColor: FluTheme.itemHoverColor
    property color maximizePressColor: FluTheme.itemPressColor
    property color closeNormalColor: Qt.rgba(0,0,0,0)
    property color closeHoverColor: Qt.rgba(251/255,115/255,115/255,1)
    property color closePressColor: Qt.rgba(251/255,115/255,115/255,0.8)
}
