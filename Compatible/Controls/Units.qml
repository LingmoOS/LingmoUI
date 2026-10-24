pragma Singleton

import QtQuick 2.4
import QtQuick.Window 2.2
import LingmoUI.CompatibleModule as LingmoUI

QtObject {
    id: units

	readonly property double rowHeight: iconSizes.large * 0.95
	readonly property double rowHeightAlt: rowHeight * 0.8

    /**
     * The fundamental unit of space that should be used for sizes, expressed in pixels.
     * Given the screen has an accurate DPI settings, it corresponds to the height of
     * the font's boundingRect.
     */
    property int gridUnit: fontMetrics.height

    property int extendBorderWidth: 0

    /**
     * units.iconSizes provides access to platform-dependent icon sizing
     *
     * The icon sizes provided are normalized for different DPI, so icons
     * will scale depending on the DPI.
     *
     * Icon sizes from KIconLoader, adjusted to devicePixelRatio:
     * * small
     * * smallMedium
     * * medium
     * * large
     * * huge
     * * enormous
     *
     * Not devicePixelRation-adjusted::
     * * desktop
     */
    property QtObject iconSizes: QtObject {
        property int small: 16
        property int smallMedium: 22
        property int medium: 32
        property int large: 48
        property int huge: 64
        property int enormous: 128
    }

    /**
     * units.smallSpacing is the amount of spacing that should be used around smaller UI elements,
     * for example as spacing in Columns. Internally, this size depends on the size of
     * the default font as rendered on the screen, so it takes user-configured font size and DPI
     * into account.
     */
    // property int smallSpacing: Math.floor(gridUnit / 4)
    property int smallSpacing: 6

    /**
     * units.largeSpacing is the amount of spacing that should be used inside bigger UI elements,
     * for example between an icon and the corresponding text. Internally, this size depends on
     * the size of the default font as rendered on the screen, so it takes user-configured font
     * size and DPI into account.
     */
    property int largeSpacing: smallSpacing * 2

    /**
     * The ratio between physical and device-independent pixels. This value does not depend on the \
     * size of the configured font. If you want to take font sizes into account when scaling elements,
     * use theme.mSize(theme.defaultFont), units.smallSpacing and units.largeSpacing.
     * The devicePixelRatio follows the definition of "device independent pixel" by Microsoft.
     */
    property real devicePixelRatio: Screen.devicePixelRatio

    /**
     * metrics used by the default font
     */
    property variant fontMetrics: FontMetrics {
        function roundedIconSize(size) {
            if (size < 16) {
                return size;
            } else if (size < 22) {
                return 16;
            } else if (size < 32) {
                return 22;
            } else if (size < 48) {
                return 32;
            } else if (size < 64) {
                return 48;
            } else {
                return size;
            }
        }
    }

    // ------------------------------------------------------------------
    // Design tokens (added in 3.1; see docs/ui-guidelines.md)
    // ------------------------------------------------------------------

    /**
     * Type scale, in points. Everything follows the user's font size
     * (Theme.fontSize, 9pt by default), so "Large"/"Huge" in Settings scale
     * the whole scale. Body text is one point above the system size, which
     * reads better than the old 9pt default.
     */
    readonly property real fontCaption: Math.max(8, LingmoUI.Theme.fontSize)          // 9   hints, counters, section headers
    readonly property real fontBody: LingmoUI.Theme.fontSize + 1                       // 10  regular text, buttons, list rows
    readonly property real fontSubheading: LingmoUI.Theme.fontSize + 3                 // 12  card titles, page titles in a detail pane
    readonly property real fontHeading: Math.round((LingmoUI.Theme.fontSize + 1) * 1.4) // 14 section headings, dialog titles
    readonly property real fontTitle: Math.round((LingmoUI.Theme.fontSize + 1) * 1.7)   // 17 app title in the sidebar, page headers
    readonly property real fontDisplay: Math.round((LingmoUI.Theme.fontSize + 1) * 2.6) // 26 big numbers, hero text

    /**
     * Motion durations in milliseconds. Hover/press feedback uses
     * veryShortDuration, most state changes shortDuration, page and panel
     * transitions longDuration.
     */
    readonly property int veryShortDuration: 100
    readonly property int shortDuration: 150
    // With "reduce motion" (Theme.reduceMotion) panels and big transitions
    // become short fades
    readonly property int longDuration: LingmoUI.Theme.reduceMotion ? shortDuration : 250
    readonly property int veryLongDuration: LingmoUI.Theme.reduceMotion ? shortDuration : 400
    readonly property int easing: Easing.OutCubic

    /**
     * Springs (SpringAnimation) for morphing shapes such as the status bar
     * Island. springEnabled is false with "reduce motion": use a short
     * NumberAnimation instead.
     */
    readonly property bool springEnabled: !LingmoUI.Theme.reduceMotion
    readonly property real spring: 4.2
    readonly property real springDamping: 0.34
    readonly property real springMass: 1.0
    readonly property real springEpsilon: 0.25

    /**
     * Fixed control sizes shared by the components.
     */
    readonly property int controlHeight: 34            // ActionButton, TextField rows
    readonly property int smallControlHeight: 28       // IconButton, compact buttons
    readonly property int windowHeaderHeight: 40       // header.height used by Lingmo apps
    readonly property int windowControlsInset: 84      // width taken by close/min/zoom at the top-left
    readonly property int sideBarWidth: 230
    readonly property int iconTileSize: 26             // coloured tile in sidebars
    readonly property int iconTileRadius: 7
}
