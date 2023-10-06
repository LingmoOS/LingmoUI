pragma Singleton

import QtQuick 2.4
import LingmoUI.Core 1.0 as LingmoUICore

QtObject {
    id: theme

    property real devicePixelRatio: LingmoUICore.ThemeManager.devicePixelRatio

    property bool darkMode: LingmoUICore.ThemeManager.darkMode

    property color blueColor: LingmoUICore.ThemeManager.blueColor
    property color redColor: LingmoUICore.ThemeManager.redColor
    property color greenColor: LingmoUICore.ThemeManager.greenColor
    property color purpleColor: LingmoUICore.ThemeManager.purpleColor
    property color pinkColor: LingmoUICore.ThemeManager.pinkColor
    property color orangeColor: LingmoUICore.ThemeManager.orangeColor
    property color greyColor: LingmoUICore.ThemeManager.greyColor

    property color backgroundColor: darkMode ? "#1C1C1D" : "#F3F4F9"
    property color secondBackgroundColor: darkMode ? "#2C2C2D" : "#FFFFFF"
    property color alternateBackgroundColor: darkMode ? "#3C3C3D" : "#F2F4F5"

    property color textColor: darkMode ? "#FFFFFF" : "#323238"
    property color disabledTextColor: darkMode ? "#888888" : "#64646E"

    property color settingsTextColor: darkMode ? "#787575" : "#C1C1CE"

    property color highlightColor: LingmoUICore.ThemeManager.accentColor
    property color highlightedTextColor: darkMode ? "#FFFFFF" : "#FFFFFF"

    property color activeTextColor: "#0176D3"
    property color activeBackgroundColor: "#0176D3"
    
    property color linesColor: "#0059FF"
    property color hoColor: "#B8B8B8"
    property color bcXColor: darkMode ? "#000000" : "#FFFFFF"
    property color fabcXColor: darkMode ? "#3C3C3D" : "#E2E3E4"
    property color nflatBoColor: "#FF5787"
    property color winMaxColor: "#1EC700"
    property color winMinColor: "#D5E400"
    property color wBoColor: darkMode ? "#FF618E" : "#FFBCCF"

    property color linkColor: "#2196F3"
    property color linkBackgroundColor: "#2196F3"
    property color visitedLinkColor: "#2196F3"
    property color visitedLinkBackgroundColor: "#2196F3"

    property real fontSize: LingmoUICore.ThemeManager.fontSize
    property string fontFamily: LingmoUICore.ThemeManager.fontFamily

    property real smallRadius: 8.0 // 8.0
    property real mediumRadius: 10.0 // 10.0
    property real bigRadius: 12.0 // 12.0
    property real hugeRadius: 14.0 // 14.0
    property real windowRadius: 11.0 // 11.0

    property var renderType: Text.QtRendering

    property font defaultFont: fontMetrics.font
    property font smallFont: {
        let font = fontMetrics.font
        if (!!font.pixelSize) {
            font.pixelSize =- 2
        } else {
            font.pointSize =- 2
        }
        return font
    }

    property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
    ]
}
