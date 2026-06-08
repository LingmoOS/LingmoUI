import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import LingmoUI

LingmoScrollablePage {
    title: qsTr("Liquid Glass")

    LingmoText {
        text: qsTr("A glass morphism lens effect with superellipse shape, refraction, blur, noise, and glow.")
    }

    // ═══════════════════════════════════════════════════════════
    // Preview — desktop wallpaper loaded directly by C++ renderer
    // ═══════════════════════════════════════════════════════════
    LingmoFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 320
        Layout.topMargin: 10

        // Glass lens — renderer loads the wallpaper file directly via QImage(path)
        LingmoLiquidGlass {
            id: glassPreview
            anchors.fill: parent
            backgroundSource: LingmoTheme.desktopImagePath
            glassWidth: widthSlider.value
            glassHeight: heightSlider.value
            powerFactor: powerSlider.value
            blurRadius: blurSlider.value
            noiseStrength: noiseSlider.value
            glowWeight: glowSlider.value
            glowBias: glowBiasSlider.value
            glowEdge0: glowEdge0Slider.value
            glowEdge1: glowEdge1Slider.value
            refractionA: aSlider.value
            refractionB: bSlider.value
            refractionC: cSlider.value
            refractionD: dSlider.value
            refractionPower: fPowerSlider.value
            mouseControl: mouseToggle.checked
            glassPosition: mouseToggle.checked
                ? Qt.point(mouseArea.mouseX / width, mouseArea.mouseY / height)
                : Qt.point(centerXSlider.value, centerYSlider.value)
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: mouseToggle.checked
            hoverEnabled: true
        }
    }

    // ═══════════════════════════════════════════════════════════
    // Controls
    // ═══════════════════════════════════════════════════════════

    LingmoText {
        Layout.topMargin: 20
        text: qsTr("Parameters")
    }

    // -- Shape --
    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            RowLayout {
                LingmoText { text: qsTr("Power Factor"); Layout.preferredWidth: 120 }
                Slider {
                    id: powerSlider
                    Layout.fillWidth: true
                    from: 1.01; to: 6.0; value: 3.0
                }
                LingmoText { text: Number(powerSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glass Width"); Layout.preferredWidth: 120 }
                Slider {
                    id: widthSlider
                    Layout.fillWidth: true
                    from: 0.5; to: 10.0; value: 3.5
                }
                LingmoText { text: Number(widthSlider.value).toFixed(1); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glass Height"); Layout.preferredWidth: 120 }
                Slider {
                    id: heightSlider
                    Layout.fillWidth: true
                    from: 0.5; to: 10.0; value: 3.5
                }
                LingmoText { text: Number(heightSlider.value).toFixed(1); Layout.preferredWidth: 40 }
            }
        }
    }

    // -- Blur, Noise & Glow --
    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            RowLayout {
                LingmoText { text: qsTr("Blur Radius"); Layout.preferredWidth: 120 }
                Slider {
                    id: blurSlider
                    Layout.fillWidth: true
                    from: 0.1; to: 8.0; value: 2.0
                }
                LingmoText { text: Number(blurSlider.value).toFixed(1); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Noise Strength"); Layout.preferredWidth: 120 }
                Slider {
                    id: noiseSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 0.3; value: 0.06
                }
                LingmoText { text: Number(noiseSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glow Weight"); Layout.preferredWidth: 120 }
                Slider {
                    id: glowSlider
                    Layout.fillWidth: true
                    from: -1.0; to: 1.0; value: 0.25
                }
                LingmoText { text: Number(glowSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glow Bias"); Layout.preferredWidth: 120 }
                Slider {
                    id: glowBiasSlider
                    Layout.fillWidth: true
                    from: -1.0; to: 1.0; value: 0.0
                }
                LingmoText { text: Number(glowBiasSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glow Edge 0"); Layout.preferredWidth: 120 }
                Slider {
                    id: glowEdge0Slider
                    Layout.fillWidth: true
                    from: -1.0; to: 1.0; value: 0.5
                }
                LingmoText { text: Number(glowEdge0Slider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Glow Edge 1"); Layout.preferredWidth: 120 }
                Slider {
                    id: glowEdge1Slider
                    Layout.fillWidth: true
                    from: -1.0; to: 1.0; value: -0.5
                }
                LingmoText { text: Number(glowEdge1Slider.value).toFixed(2); Layout.preferredWidth: 40 }
            }
        }
    }

    // -- Interaction --
    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            RowLayout {
                LingmoText { text: qsTr("Mouse Control"); Layout.preferredWidth: 120 }
                LingmoCheckBox {
                    id: mouseToggle
                    checked: false
                }
            }

            RowLayout {
                LingmoText { text: qsTr("Center X"); Layout.preferredWidth: 120 }
                Slider {
                    id: centerXSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: 0.5
                    enabled: !mouseToggle.checked
                }
                LingmoText { text: Number(centerXSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Center Y"); Layout.preferredWidth: 120 }
                Slider {
                    id: centerYSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: 0.5
                    enabled: !mouseToggle.checked
                }
                LingmoText { text: Number(centerYSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }
        }
    }

    // -- Refraction --
    LingmoFrame {
        Layout.fillWidth: true
        Layout.topMargin: 10
        leftPadding: 10; rightPadding: 10; topPadding: 6; bottomPadding: 6

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            LingmoText { text: qsTr("Refraction Curve: f(x) = 1 - b·(c·e)^(-d·x - a)") }

            RowLayout {
                LingmoText { text: "a"; Layout.preferredWidth: 120 }
                Slider {
                    id: aSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 5.0; value: 0.7
                }
                LingmoText { text: Number(aSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: "b"; Layout.preferredWidth: 120 }
                Slider {
                    id: bSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 6.0; value: 2.3
                }
                LingmoText { text: Number(bSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: "c"; Layout.preferredWidth: 120 }
                Slider {
                    id: cSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 6.0; value: 5.2
                }
                LingmoText { text: Number(cSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: "d"; Layout.preferredWidth: 120 }
                Slider {
                    id: dSlider
                    Layout.fillWidth: true
                    from: 0.0; to: 10.0; value: 6.9
                }
                LingmoText { text: Number(dSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }

            RowLayout {
                LingmoText { text: qsTr("Refraction Power"); Layout.preferredWidth: 120 }
                Slider {
                    id: fPowerSlider
                    Layout.fillWidth: true
                    from: -1.5; to: 6.0; value: 1.0
                }
                LingmoText { text: Number(fPowerSlider.value).toFixed(2); Layout.preferredWidth: 40 }
            }
        }
    }
}
