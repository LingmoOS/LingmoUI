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

#ifndef WINDOWBLUR_H
#define WINDOWBLUR_H

#include <QApplication>
#include <QObject>
#include <QQmlEngine>
#include <QQmlParserStatus>
#include <QRect>
#include <QVector>
#include <QWindow>

class WindowBlur : public QObject, public QQmlParserStatus {
    Q_OBJECT
    Q_PROPERTY(QWindow* view READ view WRITE setView NOTIFY viewChanged)
    Q_PROPERTY(QRect geometry READ geometry WRITE setGeometry NOTIFY geometryChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(qreal windowRadius READ windowRadius WRITE setWindowRadius NOTIFY windowRadiusChanged)
    // Only blur this part of the window (window coordinates, rounded by
    // windowRadius). Empty = the whole window. GlassSurface sets it.
    Q_PROPERTY(QRectF blurRect READ blurRect WRITE setBlurRect NOTIFY blurRectChanged)
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(WindowBlur)

public:
    WindowBlur(QObject* parent = nullptr) noexcept;
    ~WindowBlur() override;

    void classBegin() override;
    void componentComplete() override;

    void setView(QWindow* view);
    QWindow* view() const;

    void setGeometry(const QRect& rect);
    QRect geometry() const;

    void setEnabled(bool enabled);
    bool enabled() const;

    void setWindowRadius(qreal radius);
    qreal windowRadius() const;

    void setBlurRect(const QRectF& rect);
    QRectF blurRect() const;

private slots:
    void onViewVisibleChanged(bool);

private:
    void updateBlur();
    void updateBlurWayland();

signals:
    void viewChanged();
    void enabledChanged();
    void windowRadiusChanged();
    void geometryChanged();
    void blurRectChanged();

private:
    QWindow* m_view;
    QRect m_rect;
    bool m_enabled;
    qreal m_windowRadius;
    QRectF m_blurRect;
    // We set _KDE_NET_WM_BLUR_BEHIND_REGION ourselves (so only then remove it:
    // a disabled WindowBlur must not wipe a blur someone else asked for)
    bool m_applied = false;
};

#endif
