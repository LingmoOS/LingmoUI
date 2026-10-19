import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import LingmoUI

LingmoScrollablePage {
    title: qsTr("Liquid Glass")

    readonly property var galleryImages: [
        "qrc:/image/liquid-bkg-_0000_Comp-33.webp",
        "qrc:/image/liquid-bkg-_0001_Comp-183.webp",
        "qrc:/image/liquid-bkg-_0002_Comp-163.webp",
        "qrc:/image/liquid-bkg-_0003_Comp-151.webp",
        "qrc:/image/liquid-bkg-_0004_Comp-13.webp"
    ]

    property real sharedRefraction: refractionSlider.value
    property real sharedBevelDepth: bevelDepthSlider.value
    property real sharedBevelWidth: bevelWidthSlider.value
    property real sharedFrost: frostSlider.value
    property real sharedMagnify: magnifySlider.value
    property bool sharedSpecular: specularToggle.checked
    property bool sharedShadow: shadowToggle.checked
    property bool sharedTilt: tiltToggle.checked
    property bool sharedReveal: revealToggle.checked
    property real sharedTiltFactor: tiltFactorSlider.value

    LingmoText {
        text: qsTr("A liquidGL-style glass demo. These panes all sample a shared backdrop item so the center stays transparent while the edges refract and distort the reference background.")
        wrapMode: Text.Wrap
        Layout.fillWidth: true
    }

    LingmoText {
        visible: !LingmoTools.isOpenGL()
        text: qsTr("LiquidGlass requires the OpenGL graphics backend. The examples fall back to displaying the source image when running on Vulkan or Direct3D.")
        color: "#d68c28"
        wrapMode: Text.Wrap
        Layout.fillWidth: true
    }

    Item {
        id: heroArea
        Layout.fillWidth: true
        Layout.topMargin: 10
        Layout.preferredHeight: 360
        clip: true

        Item {
            id: heroBackdrop
            anchors.fill: parent

            Row {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: 3
                    delegate: Image {
                        width: heroArea.width / 3
                        height: heroArea.height
                        source: galleryImages[index % galleryImages.length]
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }
                }
            }
        }

        LingmoGlassNavibar {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 22
            width: Math.min(parent.width - 56, 600)
            height: 62
            backgroundTarget: heroBackdrop
            refraction: sharedRefraction
            bevelDepth: sharedBevelDepth
            bevelWidth: sharedBevelWidth
            frost: sharedFrost
            magnify: sharedMagnify
            specular: sharedSpecular
            tilt: false
            reveal: sharedReveal
            shadow: sharedShadow

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                spacing: 14

                LingmoText {
                    text: "LingmoUI"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                    opacity: 0.92
                }

                Item { Layout.fillWidth: true }

                Repeater {
                    model: [qsTr("Home"), qsTr("Products"), qsTr("About"), qsTr("Contact")]
                    delegate: LingmoText {
                        text: modelData
                        font.pixelSize: 13
                        color: "#ffffff"
                        opacity: 0.85
                    }
                }
            }
        }

        LingmoGlassCard {
            anchors.centerIn: parent
            width: 340
            height: 200
            backgroundTarget: heroBackdrop
            refraction: sharedRefraction
            bevelDepth: Math.max(sharedBevelDepth, 0.1)
            bevelWidth: Math.max(sharedBevelWidth, 0.17)
            frost: sharedFrost
            magnify: sharedMagnify
            specular: sharedSpecular
            tilt: sharedTilt
            tiltFactor: sharedTiltFactor
            reveal: sharedReveal
            shadow: sharedShadow

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Image {
                        source: "qrc:/image/card-chip.svg"
                        sourceSize.width: 40
                        sourceSize.height: 28
                        fillMode: Image.PreserveAspectFit
                    }

                    Item { Layout.fillWidth: true }

                    Image {
                        source: "qrc:/image/visa.png"
                        sourceSize.width: 54
                        sourceSize.height: 18
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Item { Layout.fillHeight: true }

                LingmoText {
                    text: "****  ****  ****  5482"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#ffffff"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 24
                    LingmoText { text: qsTr("CARD HOLDER\nNaughtyDuk LTD"); color: "#ffffff"; opacity: 0.72; font.pixelSize: 10 }
                    LingmoText { text: qsTr("EXPIRES\n12/28"); color: "#ffffff"; opacity: 0.72; font.pixelSize: 10 }
                }
            }
        }
    }

    LingmoText {
        Layout.topMargin: 20
        text: qsTr("Parameters")
    }

    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            RowLayout {
                LingmoText { text: qsTr("Refraction"); Layout.preferredWidth: 130 }
                LingmoSlider { id: refractionSlider; Layout.fillWidth: true; from: 0.0; to: 0.12; value: 0.0 }
                LingmoText { text: Number(refractionSlider.value).toFixed(3); Layout.preferredWidth: 45 }
            }
            RowLayout {
                LingmoText { text: qsTr("Bevel Depth"); Layout.preferredWidth: 130 }
                LingmoSlider { id: bevelDepthSlider; Layout.fillWidth: true; from: 0.0; to: 0.4; value: 0.052 }
                LingmoText { text: Number(bevelDepthSlider.value).toFixed(3); Layout.preferredWidth: 45 }
            }
            RowLayout {
                LingmoText { text: qsTr("Bevel Width"); Layout.preferredWidth: 130 }
                LingmoSlider { id: bevelWidthSlider; Layout.fillWidth: true; from: 0.02; to: 0.6; value: 0.211 }
                LingmoText { text: Number(bevelWidthSlider.value).toFixed(3); Layout.preferredWidth: 45 }
            }
            RowLayout {
                LingmoText { text: qsTr("Frost"); Layout.preferredWidth: 130 }
                LingmoSlider { id: frostSlider; Layout.fillWidth: true; from: 0.0; to: 10.0; value: 2.0 }
                LingmoText { text: Number(frostSlider.value).toFixed(1); Layout.preferredWidth: 45 }
            }
            RowLayout {
                LingmoText { text: qsTr("Magnify"); Layout.preferredWidth: 130 }
                LingmoSlider { id: magnifySlider; Layout.fillWidth: true; from: 0.7; to: 1.5; value: 1.0 }
                LingmoText { text: Number(magnifySlider.value).toFixed(2); Layout.preferredWidth: 45 }
            }
            RowLayout {
                LingmoText { text: qsTr("Tilt Factor"); Layout.preferredWidth: 130 }
                LingmoSlider { id: tiltFactorSlider; Layout.fillWidth: true; from: 0.0; to: 25.0; value: 25.0 }
                LingmoText { text: Number(tiltFactorSlider.value).toFixed(1); Layout.preferredWidth: 45 }
            }
        }
    }

    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        RowLayout {
            anchors.fill: parent
            spacing: 16

            LingmoCheckBox { id: specularToggle; checked: true }
            LingmoText { text: qsTr("Specular") }
            LingmoCheckBox { id: shadowToggle; checked: true }
            LingmoText { text: qsTr("Shadow") }
            LingmoCheckBox { id: tiltToggle; checked: true }
            LingmoText { text: qsTr("Tilt") }
            LingmoCheckBox { id: revealToggle; checked: false }
            LingmoText { text: qsTr("Reveal") }
        }
    }

    LingmoText {
        Layout.topMargin: 24
        text: qsTr("Card gallery")
    }

    RowLayout {
        Layout.topMargin: 10
        Layout.fillWidth: true
        spacing: 16

        Repeater {
            model: 2
            delegate: Item {
                width: 300
                height: 180

                Item {
                    id: cardBackdrop
                    anchors.fill: parent

                    Image {
                        anchors.fill: parent
                        source: galleryImages[(index + 2) % galleryImages.length]
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }
                }

                LingmoGlassCard {
                    anchors.fill: parent
                    backgroundTarget: cardBackdrop
                    refraction: sharedRefraction
                    bevelDepth: index === 0 ? Math.max(sharedBevelDepth, 0.1) : sharedBevelDepth
                    bevelWidth: index === 0 ? Math.max(sharedBevelWidth, 0.17) : sharedBevelWidth
                    frost: sharedFrost
                    magnify: sharedMagnify
                    specular: sharedSpecular
                    tilt: sharedTilt
                    tiltFactor: sharedTiltFactor
                    reveal: sharedReveal
                    shadow: sharedShadow

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            visible: index === 0
                            Image { source: "qrc:/image/card-chip.svg"; sourceSize.width: 34; sourceSize.height: 24; fillMode: Image.PreserveAspectFit }
                            Item { Layout.fillWidth: true }
                            Image { source: "qrc:/image/visa.png"; sourceSize.width: 48; sourceSize.height: 16; fillMode: Image.PreserveAspectFit }
                        }

                        LingmoText { text: index === 0 ? qsTr("VISA PREMIUM") : qsTr("PRO PLAN"); font.pixelSize: 14; color: "#ffffff"; opacity: 0.78 }
                        Item { Layout.fillHeight: true }
                        LingmoText { text: index === 0 ? "****  ****  ****  8421" : qsTr("$29/mo"); font.pixelSize: index === 0 ? 18 : 28; color: "#ffffff"; font.bold: true }
                        LingmoText { text: index === 0 ? qsTr("VALID THRU 12/28") : qsTr("Unlimited projects, priority support"); font.pixelSize: 10; color: "#ffffff"; opacity: 0.68 }
                    }
                }
            }
        }
    }

    LingmoText {
        Layout.topMargin: 24
        text: qsTr("Shared backdrop navbar")
    }

    Item {
        id: navPreviewArea
        width: parent.width
        Layout.fillWidth: true
        Layout.topMargin: 10
        Layout.preferredHeight: 88

        Item {
            id: navBackdrop
            anchors.fill: parent

            Row {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: 4
                    delegate: Image {
                        width: navPreviewArea.width / 4
                        height: navPreviewArea.height
                        source: galleryImages[(index + 1) % galleryImages.length]
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }
                }
            }
        }

        LingmoGlassNavibar {
            anchors {
                left: parent.left; right: parent.right
                margins: 12
                verticalCenter: parent.verticalCenter
            }
            backgroundTarget: navBackdrop
            refraction: sharedRefraction
            bevelDepth: sharedBevelDepth
            bevelWidth: sharedBevelWidth
            frost: sharedFrost
            magnify: sharedMagnify
            specular: sharedSpecular
            tilt: false
            reveal: sharedReveal
            shadow: sharedShadow

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                LingmoText {
                    text: "LingmoUI"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                    opacity: 0.92
                }

                Item { Layout.fillWidth: true }

                Repeater {
                    model: [qsTr("Home"), qsTr("Products"), qsTr("About"), qsTr("Contact")]
                    delegate: LingmoText {
                        text: modelData
                        font.pixelSize: 13
                        color: "#ffffff"
                        opacity: 0.85
                    }
                }
            }
        }
    }
}
