import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LingmoUI.GraphicalEffects
import LingmoUI.CompatibleModule as LingmoUI

LingmoUI.Window {
    id: control

    width: 300
    height: contentHeight

    maximumWidth: control.width
    minimumWidth: control.width

    maximumHeight: contentHeight
    minimumHeight: contentHeight

    modality: Qt.WindowModal
    flags: Qt.Dialog | Qt.FramelessWindowHint

    minimizeButtonVisible: false
    visible: false

    property var iconSource
    property string name
    property string description
    property string link: "https://lingmo.org"
    property var contentHeight: _mainLayout.implicitHeight + control.header.height * 2

    background.opacity: control.compositing ? 0.6 : 1.0

    LingmoUI.WindowBlur {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        windowRadius: control.windowRadius
        enabled: control.compositing
    }

    DragHandler {
        target: null
        acceptedDevices: PointerDevice.GenericPointer
        grabPermissions: PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
        onActiveChanged: if (active) { control.helper.startSystemMove(control) }
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.bottomMargin: control.header.height

        Image {
            width: 64
            height: 64
            source: control.iconSource
            sourceSize: Qt.size(64, 64)
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            height: LingmoUI.Units.largeSpacing
        }

        Label {
            text: control.name
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: 14
        }

        Label {
            text: control.description
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "<a href=\"%1\">%1</a>".arg(control.link)
            Layout.alignment: Qt.AlignHCenter
            linkColor: LingmoUI.Theme.highlightColor

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Qt.openUrlExternally(control.link)
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
