/*
 * Copyright (C) 2021 LingmoOS Team.
 *
 * Author:     lingmo <lingmo@lingmo.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "windowblur.h"

#include <QApplication>
#include <QPainterPath>
#include <QScreen>
#include <QtGui/private/qtx11extras_p.h>

#include <xcb/shape.h>
#include <xcb/xcb.h>
#include <xcb/xcb_icccm.h>

#ifdef KF_WINDOWSYSTEM_FOUND
#include <KWindowEffects>
#endif

static bool isWayland()
{
    return QGuiApplication::platformName().startsWith(QLatin1String("wayland"));
}

WindowBlur::WindowBlur(QObject* parent) noexcept
    : QObject(parent)
    , m_view(nullptr)
    , m_enabled(false)
    , m_windowRadius(0.0)
{
}

WindowBlur::~WindowBlur() { }

void WindowBlur::classBegin() { }

void WindowBlur::componentComplete() { updateBlur(); }

void WindowBlur::setView(QWindow* view)
{
    if (view != m_view) {
        if (m_view)
            disconnect(m_view, nullptr, this, nullptr);
        m_view = view;
        m_applied = false;
        updateBlur();
        emit viewChanged();

        if (m_view) {
            connect(m_view, &QWindow::visibleChanged, this,
                &WindowBlur::onViewVisibleChanged);
            // The whole-window region follows the window's size
            connect(m_view, &QWindow::widthChanged, this, [this] { if (m_blurRect.isEmpty()) updateBlur(); });
            connect(m_view, &QWindow::heightChanged, this, [this] { if (m_blurRect.isEmpty()) updateBlur(); });
        }
    }
}

QWindow* WindowBlur::view() const { return m_view; }

void WindowBlur::setGeometry(const QRect& rect)
{
    if (rect != m_rect) {
        m_rect = rect;
        updateBlur();
        emit geometryChanged();
    }
}

QRect WindowBlur::geometry() const { return m_rect; }

void WindowBlur::setEnabled(bool enabled)
{
    if (enabled != m_enabled) {
        m_enabled = enabled;
        updateBlur();
        emit enabledChanged();
    }
}

bool WindowBlur::enabled() const { return m_enabled; }

void WindowBlur::setWindowRadius(qreal radius)
{
    if (radius != m_windowRadius) {
        m_windowRadius = radius;
        updateBlur();
        emit windowRadiusChanged();
    }
}

qreal WindowBlur::windowRadius() const { return m_windowRadius; }

void WindowBlur::setBlurRect(const QRectF& rect)
{
    if (rect != m_blurRect) {
        m_blurRect = rect;
        updateBlur();
        emit blurRectChanged();
    }
}

QRectF WindowBlur::blurRect() const { return m_blurRect; }

void WindowBlur::onViewVisibleChanged(bool visible)
{
    if (visible)
        updateBlur();
}

void WindowBlur::updateBlur()
{
    if (isWayland()) {
        updateBlurWayland();
        return;
    }

    if (!m_view || !m_view->handle())
        return;

    xcb_connection_t* c = QX11Info::connection();
    if (!c)
        return;

    const QByteArray effectName = QByteArrayLiteral("_KDE_NET_WM_BLUR_BEHIND_REGION");
    xcb_intern_atom_cookie_t atomCookie = xcb_intern_atom_unchecked(
        c, false, effectName.length(), effectName.constData());
    QScopedPointer<xcb_intern_atom_reply_t, QScopedPointerPodDeleter> atom(
        xcb_intern_atom_reply(c, atomCookie, nullptr));
    if (!atom)
        return;

    if (m_enabled) {
        qreal devicePixelRatio = m_view->screen()->devicePixelRatio();
        QPainterPath path;
        const QRectF area = m_blurRect.isEmpty()
            ? QRectF(QPoint(0, 0), m_view->size() * devicePixelRatio)
            : QRectF(m_blurRect.topLeft() * devicePixelRatio, m_blurRect.size() * devicePixelRatio);
        path.addRoundedRect(area,
            m_windowRadius * devicePixelRatio,
            m_windowRadius * devicePixelRatio);
        QVector<uint32_t> data;
        foreach (const QPolygonF& polygon, path.toFillPolygons()) {
            QRegion region = polygon.toPolygon();
            for (auto i = region.begin(); i != region.end(); ++i) {
                data << i->x() << i->y() << i->width() << i->height();
            }
        }

        xcb_change_property(c, XCB_PROP_MODE_REPLACE, m_view->winId(), atom->atom,
            XCB_ATOM_CARDINAL, 32, data.size(), data.constData());
        m_applied = true;

    } else if (m_applied) {
        xcb_delete_property(c, m_view->winId(), atom->atom);
        m_applied = false;
    }
}

// Wayland: org_kde_kwin_blur through KWindowEffects, in logical coordinates. KWindowEffects
// keeps the region and sends it again whenever the surface is (re)created, so this also
// works before the window is shown.
void WindowBlur::updateBlurWayland()
{
#ifdef KF_WINDOWSYSTEM_FOUND
    if (!m_view)
        return;

    if (m_enabled) {
        QPainterPath path;
        const QRectF area = m_blurRect.isEmpty() ? QRectF(QPointF(0, 0), m_view->size()) : m_blurRect;
        path.addRoundedRect(area, m_windowRadius, m_windowRadius);
        QRegion region;
        for (const QPolygonF &polygon : path.toFillPolygons())
            region += QRegion(polygon.toPolygon());
        KWindowEffects::enableBlurBehind(m_view, true, region);
        m_applied = true;
    } else if (m_applied) {
        KWindowEffects::enableBlurBehind(m_view, false);
        m_applied = false;
    }
#endif
}
