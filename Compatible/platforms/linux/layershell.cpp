/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "layershell.h"

#include <QDebug>
#include <QEvent>
#include <QGuiApplication>
#include <QQuickItem>
#include <QQuickWindow>
#include <QScreen>

#ifdef HAVE_LAYERSHELLQT
#include <LayerShellQt/Window>
#endif

namespace {

bool isWayland()
{
    return QGuiApplication::platformName().startsWith(QLatin1String("wayland"));
}

#ifdef HAVE_LAYERSHELLQT
LayerShellQt::Window *lsw(void *p)
{
    return static_cast<LayerShellQt::Window *>(p);
}
#endif

} // namespace

LayerShell::LayerShell(QObject *parent)
    : QObject(parent)
{
    if (auto *window = qobject_cast<QWindow *>(parent)) {
        setWindow(window);
    } else if (auto *item = qobject_cast<QQuickItem *>(parent)) {
        // An item: the layer goes to the window it ends up in
        m_item = item;
        connect(item, &QQuickItem::windowChanged, this, [this](QQuickWindow *w) { setWindow(w); });
        setWindow(item->window());
    }
}

LayerShell::~LayerShell() = default;

LayerShell *LayerShell::qmlAttachedProperties(QObject *object)
{
    return new LayerShell(object);
}

bool LayerShell::supported()
{
#ifdef HAVE_LAYERSHELLQT
    return isWayland();
#else
    return false;
#endif
}

bool LayerShell::active() const
{
    return m_attached && m_enabled;
}

void LayerShell::setWindow(QWindow *window)
{
    if (m_window == window)
        return;
    if (m_window) {
        disconnect(m_window, nullptr, this, nullptr);
        m_window->removeEventFilter(this);
    }
    m_window = window;
    m_layerWindow = nullptr;
    const bool wasActive = active();
    m_attached = false;
    if (m_window) {
        connect(m_window, &QWindow::xChanged, this, &LayerShell::applyPosition);
        connect(m_window, &QWindow::yChanged, this, &LayerShell::applyPosition);
        // The role is given on the window's Show event (after create(), before
        // the shell surface exists), so every attached property is in by then:
        // QML applies `visible` when the window is complete
        m_window->installEventFilter(this);
        if (m_window->isVisible())
            QMetaObject::invokeMethod(this, [this] { attach(false); }, Qt::QueuedConnection);
    }
    if (wasActive != active())
        emit activeChanged();
}

bool LayerShell::eventFilter(QObject *watched, QEvent *event)
{
    if (watched == m_window && event->type() == QEvent::Show && !m_attached)
        attach(true);
    return QObject::eventFilter(watched, event);
}

void LayerShell::attach(bool fromShowEvent)
{
#ifdef HAVE_LAYERSHELLQT
    if (m_attached || !m_enabled || !m_window || !supported())
        return;

    // The layer-shell role is chosen when the platform window gets its shell
    // surface (on show): a window on screen has to go through that again
    const bool wasVisible = !fromShowEvent && m_window->isVisible();
    if (wasVisible)
        m_window->setVisible(false);
    if (wasVisible && m_window->handle())
        m_window->destroy();

    LayerShellQt::Window *w = LayerShellQt::Window::get(m_window);
    if (!w) {
        qWarning() << "LayerShell: no layer-shell surface for" << m_window;
        if (wasVisible)
            m_window->setVisible(true);
        return;
    }
    m_layerWindow = w;
    m_attached = true;
    m_showing = fromShowEvent;
    apply();
    m_showing = false;
    if (wasVisible)
        m_window->setVisible(true);
    emit activeChanged();
#endif
}

QScreen *LayerShell::resolvedScreen() const
{
    if (m_screen.isValid() && !m_screen.isNull()) {
        if (auto *s = qobject_cast<QScreen *>(m_screen.value<QObject *>()))
            return s;
        // Qt.application.screens[i] (QQuickScreenInfo) or a name
        QString name = m_screen.toString();
        if (QObject *o = m_screen.value<QObject *>())
            name = o->property("name").toString();
        for (QScreen *s : QGuiApplication::screens()) {
            if (s->name() == name)
                return s;
        }
    }
    if (m_positionFromWindow && m_window) {
        if (QScreen *s = QGuiApplication::screenAt(m_window->position()))
            return s;
    }
    return nullptr;
}

void LayerShell::apply()
{
#ifdef HAVE_LAYERSHELLQT
    if (!m_attached || !m_layerWindow)
        return;
    LayerShellQt::Window *w = lsw(m_layerWindow);

    if (!m_scope.isEmpty())
        w->setScope(m_scope);
    w->setLayer(static_cast<LayerShellQt::Window::Layer>(m_layer));
    w->setKeyboardInteractivity(static_cast<LayerShellQt::Window::KeyboardInteractivity>(m_keyboard));
    w->setActivateOnShow(m_activateOnShow);
    // positionFromWindow: margins from the output edges, whatever panels reserve
    w->setExclusiveZone(m_positionFromWindow ? -1 : m_exclusiveZone);

    if (m_positionFromWindow) {
        applyPosition();
    } else {
        w->setAnchors(LayerShellQt::Window::Anchors(int(m_anchors)));
        w->setMargins(m_margins);
    }

    QScreen *screen = resolvedScreen();
    if (screen && screen != w->screen()) {
        // The output is fixed when the surface is created
        const bool visible = !m_showing && m_window->isVisible();
        if (visible)
            m_window->setVisible(false);
        m_window->setScreen(screen);
        w->setScreen(screen);
        if (visible)
            m_window->setVisible(true);
    }
#endif
}

void LayerShell::applyPosition()
{
#ifdef HAVE_LAYERSHELLQT
    if (!m_attached || !m_layerWindow || !m_positionFromWindow || !m_window)
        return;
    LayerShellQt::Window *w = lsw(m_layerWindow);
    QScreen *screen = resolvedScreen();
    if (!screen)
        screen = m_window->screen();
    const QRect g = screen ? screen->geometry() : QRect();
    w->setAnchors(LayerShellQt::Window::Anchors(LayerShellQt::Window::AnchorTop | LayerShellQt::Window::AnchorLeft));
    w->setMargins(QMargins(qMax(0, m_window->x() - g.x()), qMax(0, m_window->y() - g.y()), 0, 0));
    if (screen && screen != w->screen() && !m_window->isVisible())
        w->setScreen(screen);
#endif
}

void LayerShell::setEnabled(bool enabled)
{
    if (m_enabled == enabled)
        return;
    m_enabled = enabled;
    // Only takes effect before the window is shown the first time: a layer
    // surface can't turn back into a normal window
    if (m_enabled && m_window && m_window->isVisible())
        attach(false);
    emit enabledChanged();
    emit activeChanged();
}

void LayerShell::setLayer(Layer layer)
{
    if (m_layer == layer)
        return;
    m_layer = layer;
    apply();
    emit layerChanged();
}

void LayerShell::setAnchors(Anchors anchors)
{
    if (m_anchors == anchors)
        return;
    m_anchors = anchors;
    apply();
    emit anchorsChanged();
}

void LayerShell::setMargins(const QMargins &margins)
{
    if (m_margins == margins)
        return;
    m_margins = margins;
    apply();
    emit marginsChanged();
}

void LayerShell::setLeftMargin(int margin)
{
    QMargins m = m_margins;
    m.setLeft(margin);
    setMargins(m);
}

void LayerShell::setTopMargin(int margin)
{
    QMargins m = m_margins;
    m.setTop(margin);
    setMargins(m);
}

void LayerShell::setRightMargin(int margin)
{
    QMargins m = m_margins;
    m.setRight(margin);
    setMargins(m);
}

void LayerShell::setBottomMargin(int margin)
{
    QMargins m = m_margins;
    m.setBottom(margin);
    setMargins(m);
}

void LayerShell::setExclusiveZone(int zone)
{
    if (m_exclusiveZone == zone)
        return;
    m_exclusiveZone = zone;
    apply();
    emit exclusiveZoneChanged();
}

void LayerShell::setKeyboardInteractivity(KeyboardInteractivity keyboard)
{
    if (m_keyboard == keyboard)
        return;
    m_keyboard = keyboard;
    apply();
    emit keyboardInteractivityChanged();
}

void LayerShell::setScope(const QString &scope)
{
    if (m_scope == scope)
        return;
    m_scope = scope;
    apply();
    emit scopeChanged();
}

void LayerShell::setScreen(const QVariant &screen)
{
    m_screen = screen;
    apply();
    emit screenChanged();
}

void LayerShell::setPositionFromWindow(bool enabled)
{
    if (m_positionFromWindow == enabled)
        return;
    m_positionFromWindow = enabled;
    apply();
    emit positionFromWindowChanged();
}

void LayerShell::setActivateOnShow(bool activate)
{
    if (m_activateOnShow == activate)
        return;
    m_activateOnShow = activate;
    apply();
    emit activateOnShowChanged();
}
