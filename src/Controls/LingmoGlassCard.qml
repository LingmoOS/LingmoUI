import QtQuick
import LingmoUI

LingmoLiquidGlass {
    id: card

    // liquidGL demo-2 bank-card style preset
    refraction: 0
    bevelDepth: 0.1
    bevelWidth: 0.17
    frost: 2.0
    magnify: 1.0
    specular: true
    shadow: true
    cornerRadius: 16

    tilt: true
    tiltFactor: 25
    reveal: false
}
