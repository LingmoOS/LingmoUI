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
}
