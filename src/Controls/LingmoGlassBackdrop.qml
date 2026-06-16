import QtQuick

Item {
    id: control

    default property alias content: contentItem.children
    property string imageSource: ""
    property real imageRadius: 16
    property bool fillHeight: true

    implicitWidth: 360
    implicitHeight: 220
    clip: true

    Image {
        anchors.fill: parent
        source: control.imageSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: control.imageSource !== ""
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
