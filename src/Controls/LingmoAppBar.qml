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

    property color textColor: LingmoTheme.fontPrimaryColor
    property color minimizeNormalColor: LingmoTheme.itemNormalColor
    property color minimizeHoverColor: LingmoTheme.itemHoverColor
    property color minimizePressColor: LingmoTheme.itemPressColor
    property color maximizeNormalColor: LingmoTheme.itemNormalColor
    property color maximizeHoverColor: LingmoTheme.itemHoverColor
    property color maximizePressColor: LingmoTheme.itemPressColor
    property color closeNormalColor: Qt.rgba(0,0,0,0)
    property color closeHoverColor: Qt.rgba(251/255,115/255,115/255,1)
    property color closePressColor: Qt.rgba(251/255,115/255,115/255,0.8)
}
