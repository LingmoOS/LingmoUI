import QtQuick
import QtQuick.Controls
import LingmoUI

Text {
    property int iconSource
    property int iconSize: 20
    property color iconColor: LingmoTheme.dark ? "#FFFFFF" : "#000000"
    id: control
    font.family: font_loader.name
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
    opacity: iconSource > 0
    FontLoader {
        id: font_loader
        source: "qrc:/lingmoui/kit/LingmoUI/Font/FluentIcons.ttf"
    }
}
