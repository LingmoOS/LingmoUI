import QtQuick
import QtQuick.Effects
import LingmoUI.CompatibleModule 3.0 as LUI

// Shared surface for menus, popups and dialogs: the Lingmo glass material
// (LUI.GlassSurface, Settings > Appearance > Glass) with a soft drop shadow.
// A popup in its own window (popupType: Popup.Window) gets KWin's blur; one
// drawn inside the app's window stays nearly opaque.
Item {
    id: surface

    property real radius: 10
    implicitWidth: 200
    implicitHeight: 40

    LUI.GlassSurface {
        anchors.fill: parent
        radius: surface.radius
        // Menus and popups float over content: always lifted
        elevated: true
        // Popups are small: no light sheen under the pointer
        sheenEnabled: false
        tint: LUI.Theme.glassEnabled ? LUI.Theme.glassTint : LUI.Theme.secondBackgroundColor
    }
}
