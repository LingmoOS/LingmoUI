/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef LINGMOUI_LAYERSHELL_H
#define LINGMOUI_LAYERSHELL_H

#include <QMargins>
#include <QObject>
#include <QPointer>
#include <QQmlEngine>
#include <QVariant>

class QQuickItem;
class QScreen;
class QWindow;

/*!
    LayerShell: puts a window in a wlr-layer-shell layer on Wayland (panels,
    docks, the desktop, overlays), through LayerShellQt. On X11 (or anything
    that is not Wayland) it does nothing, so the same QML works in both
    sessions: keep the X11 placement (x/y, flags, struts) next to it.

    \qml
    Window {
        LingmoUI.LayerShell.layer: LingmoUI.LayerShell.LayerTop
        LingmoUI.LayerShell.anchors: LingmoUI.LayerShell.AnchorTop
        LingmoUI.LayerShell.exclusiveZone: -1
        LingmoUI.LayerShell.keyboardInteractivity: LingmoUI.LayerShell.KeyboardNone
        LingmoUI.LayerShell.scope: "lingmo-island"
    }
    \endqml

    The surface is set up before the window is first shown: set the properties
    where the window is declared (a window that is already on screen is hidden,
    recreated and shown again once). Changes after that reach the compositor
    right away, except the screen, which recreates the surface.

    positionFromWindow: anchors the surface to the top and left edges of its
    screen and turns the window's x/y (global, like on X11) into margins, so
    popups placed with x/y keep working unchanged on Wayland.
*/
class LayerShell : public QObject
{
    Q_OBJECT
    // false: leave the window alone (a normal window)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    // The window really is a layer-shell surface (Wayland, LayerShellQt there)
    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(Layer layer READ layer WRITE setLayer NOTIFY layerChanged)
    Q_PROPERTY(Anchors anchors READ anchors WRITE setAnchors NOTIFY anchorsChanged)
    Q_PROPERTY(int leftMargin READ leftMargin WRITE setLeftMargin NOTIFY marginsChanged)
    Q_PROPERTY(int topMargin READ topMargin WRITE setTopMargin NOTIFY marginsChanged)
    Q_PROPERTY(int rightMargin READ rightMargin WRITE setRightMargin NOTIFY marginsChanged)
    Q_PROPERTY(int bottomMargin READ bottomMargin WRITE setBottomMargin NOTIFY marginsChanged)
    // > 0: room reserved along the anchored edge; 0: moved out of other zones;
    // -1: ignores the other surfaces' zones (fullscreen overlays)
    Q_PROPERTY(int exclusiveZone READ exclusiveZone WRITE setExclusiveZone NOTIFY exclusiveZoneChanged)
    Q_PROPERTY(KeyboardInteractivity keyboardInteractivity READ keyboardInteractivity WRITE setKeyboardInteractivity NOTIFY keyboardInteractivityChanged)
    // The layer surface's namespace ("lingmo-statusbar", "lingmo-island"...)
    Q_PROPERTY(QString scope READ scope WRITE setScope NOTIFY scopeChanged)
    // A QScreen, a screen from Qt.application.screens or a screen name; empty =
    // the window's screen
    Q_PROPERTY(QVariant screen READ screen WRITE setScreen NOTIFY screenChanged)
    Q_PROPERTY(bool positionFromWindow READ positionFromWindow WRITE setPositionFromWindow NOTIFY positionFromWindowChanged)
    Q_PROPERTY(bool activateOnShow READ activateOnShow WRITE setActivateOnShow NOTIFY activateOnShowChanged)

public:
    enum Layer {
        LayerBackground = 0,
        LayerBottom = 1,
        LayerTop = 2,
        LayerOverlay = 3,
    };
    Q_ENUM(Layer)

    enum Anchor {
        AnchorNone = 0,
        AnchorTop = 1,
        AnchorBottom = 2,
        AnchorLeft = 4,
        AnchorRight = 8,
    };
    Q_DECLARE_FLAGS(Anchors, Anchor)
    Q_FLAG(Anchors)

    enum KeyboardInteractivity {
        KeyboardNone = 0,
        KeyboardExclusive = 1,
        KeyboardOnDemand = 2,
    };
    Q_ENUM(KeyboardInteractivity)

    explicit LayerShell(QObject *parent = nullptr);
    ~LayerShell() override;

    static LayerShell *qmlAttachedProperties(QObject *object);

    // The session can use layer-shell (Wayland with LayerShellQt)
    Q_INVOKABLE static bool supported();

    bool enabled() const { return m_enabled; }
    void setEnabled(bool enabled);
    bool active() const;

    Layer layer() const { return m_layer; }
    void setLayer(Layer layer);
    Anchors anchors() const { return m_anchors; }
    void setAnchors(Anchors anchors);

    int leftMargin() const { return m_margins.left(); }
    int topMargin() const { return m_margins.top(); }
    int rightMargin() const { return m_margins.right(); }
    int bottomMargin() const { return m_margins.bottom(); }
    void setLeftMargin(int margin);
    void setTopMargin(int margin);
    void setRightMargin(int margin);
    void setBottomMargin(int margin);

    int exclusiveZone() const { return m_exclusiveZone; }
    void setExclusiveZone(int zone);
    KeyboardInteractivity keyboardInteractivity() const { return m_keyboard; }
    void setKeyboardInteractivity(KeyboardInteractivity keyboard);
    QString scope() const { return m_scope; }
    void setScope(const QString &scope);
    QVariant screen() const { return m_screen; }
    void setScreen(const QVariant &screen);
    bool positionFromWindow() const { return m_positionFromWindow; }
    void setPositionFromWindow(bool enabled);
    bool activateOnShow() const { return m_activateOnShow; }
    void setActivateOnShow(bool activate);

signals:
    void enabledChanged();
    void activeChanged();
    void layerChanged();
    void anchorsChanged();
    void marginsChanged();
    void exclusiveZoneChanged();
    void keyboardInteractivityChanged();
    void scopeChanged();
    void screenChanged();
    void positionFromWindowChanged();
    void activateOnShowChanged();

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    void setWindow(QWindow *window);
    void setMargins(const QMargins &margins);
    QScreen *resolvedScreen() const;
    // Creates the layer surface role for the window (once) and pushes everything
    void attach(bool fromShowEvent);
    void apply();
    void applyPosition();

    QPointer<QWindow> m_window;
    QPointer<QQuickItem> m_item;
    void *m_layerWindow = nullptr; // LayerShellQt::Window, owned by the window
    bool m_attached = false;
    bool m_showing = false; // inside the window's Show event

    bool m_enabled = true;
    Layer m_layer = LayerTop;
    Anchors m_anchors = AnchorNone;
    QMargins m_margins;
    int m_exclusiveZone = 0;
    KeyboardInteractivity m_keyboard = KeyboardNone;
    QString m_scope;
    QVariant m_screen;
    bool m_positionFromWindow = false;
    bool m_activateOnShow = true;
};

Q_DECLARE_OPERATORS_FOR_FLAGS(LayerShell::Anchors)
QML_DECLARE_TYPEINFO(LayerShell, QML_HAS_ATTACHED_PROPERTIES)

#endif // LINGMOUI_LAYERSHELL_H
