/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "islandactivity.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>
#include <QDBusServiceWatcher>
#include <QPointer>

static const QString s_service = QStringLiteral("com.lingmo.Island");
static const QString s_path = QStringLiteral("/Island");
static const QString s_interface = QStringLiteral("com.lingmo.Island");

IslandActivity::IslandActivity(QObject *parent)
    : QObject(parent)
{
    m_appId = QGuiApplication::desktopFileName();
    if (m_appId.isEmpty())
        m_appId = QCoreApplication::applicationName();

    m_updateTimer.setSingleShot(true);
    m_updateTimer.setInterval(80);
    connect(&m_updateTimer, &QTimer::timeout, this, &IslandActivity::sendUpdate);

    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.connect(s_service, s_path, s_interface, QStringLiteral("ActionInvoked"),
                this, SLOT(onActionInvoked(uint,QString)));
    bus.connect(s_service, s_path, s_interface, QStringLiteral("Closed"),
                this, SLOT(onActivityClosed(uint)));

    // The status bar came back: start again
    m_watcher = new QDBusServiceWatcher(s_service, bus, QDBusServiceWatcher::WatchForOwnerChange, this);
    connect(m_watcher, &QDBusServiceWatcher::serviceOwnerChanged, this,
            [this](const QString &, const QString &, const QString &newOwner) {
        if (m_id) {
            m_id = 0;
            emit activityIdChanged();
        }
        if (!newOwner.isEmpty() && m_active && m_complete)
            start();
    });
}

IslandActivity::~IslandActivity()
{
    if (m_id) {
        QDBusMessage msg = QDBusMessage::createMethodCall(s_service, s_path, s_interface, QStringLiteral("Finish"));
        msg << m_id << QString();
        QDBusConnection::sessionBus().call(msg, QDBus::NoBlock);
    }
}

void IslandActivity::componentComplete()
{
    m_complete = true;
    if (m_active)
        start();
}

void IslandActivity::setActive(bool active)
{
    if (m_active == active)
        return;
    m_active = active;
    emit activeChanged();
    if (!m_complete)
        return;
    if (m_active) {
        // Next turn of the event loop: the other bindings (startTime, title...)
        // that changed together with active have their new values by then
        QTimer::singleShot(0, this, [this] { if (m_active) start(); });
    } else {
        finish(m_finishMessage);
    }
}

#define ISLAND_SETTER(Name, member, Type) \
    void IslandActivity::set##Name(Type v) \
    { \
        if (member == v) \
            return; \
        member = v; \
        emit changed(); \
        scheduleUpdate(); \
    }

ISLAND_SETTER(AppId, m_appId, const QString &)
ISLAND_SETTER(Kind, m_kind, const QString &)
ISLAND_SETTER(Title, m_title, const QString &)
ISLAND_SETTER(Subtitle, m_subtitle, const QString &)
ISLAND_SETTER(IconName, m_iconName, const QString &)
ISLAND_SETTER(Actions, m_actions, const QVariantList &)
ISLAND_SETTER(Hints, m_hints, const QVariantMap &)

void IslandActivity::setProgress(qreal v)
{
    if (qFuzzyCompare(m_progress + 2, v + 2))
        return;
    m_progress = v;
    emit changed();
    scheduleUpdate();
}

void IslandActivity::setFinishMessage(const QString &v)
{
    if (m_finishMessage != v) {
        m_finishMessage = v;
        emit changed();
    }
}

QStringList IslandActivity::flatActions() const
{
    QStringList out;
    for (const QVariant &a : m_actions) {
        if (a.canConvert<QVariantMap>() && a.metaType().id() != QMetaType::QString) {
            const QVariantMap m = a.toMap();
            out << m.value(QStringLiteral("id")).toString()
                << m.value(QStringLiteral("label"), m.value(QStringLiteral("text"))).toString();
        } else {
            out << a.toString();
        }
    }
    return out;
}

void IslandActivity::start()
{
    if (m_id || m_starting)
        return;
    m_starting = true;
    m_dirty = false;

    QDBusMessage msg = QDBusMessage::createMethodCall(s_service, s_path, s_interface, QStringLiteral("StartWithHints"));
    msg << m_appId << m_kind << m_title << m_subtitle << m_iconName << double(m_progress)
        << flatActions() << m_hints;

    QPointer<IslandActivity> self(this);
    auto *watcher = new QDBusPendingCallWatcher(QDBusConnection::sessionBus().asyncCall(msg), this);
    connect(watcher, &QDBusPendingCallWatcher::finished, this, [this, self](QDBusPendingCallWatcher *w) {
        w->deleteLater();
        QDBusPendingReply<uint> reply = *w;
        if (!self)
            return;
        m_starting = false;
        if (reply.isError())
            return;
        const uint id = reply.value();
        if (!m_active) {
            // Turned off while starting
            QDBusMessage fin = QDBusMessage::createMethodCall(s_service, s_path, s_interface, QStringLiteral("Finish"));
            fin << id << m_finishMessage;
            QDBusConnection::sessionBus().call(fin, QDBus::NoBlock);
            return;
        }
        m_id = id;
        emit activityIdChanged();
        // Properties changed while the call was on its way
        if (m_dirty)
            sendUpdate();
    });
}

void IslandActivity::scheduleUpdate()
{
    if (m_starting)
        m_dirty = true;
    else if (m_id)
        m_updateTimer.start();
}

void IslandActivity::sendUpdate()
{
    m_dirty = false;
    if (!m_id)
        return;
    QVariantMap fields = m_hints;
    fields.insert(QStringLiteral("title"), m_title);
    fields.insert(QStringLiteral("subtitle"), m_subtitle);
    fields.insert(QStringLiteral("iconName"), m_iconName);
    fields.insert(QStringLiteral("kind"), m_kind);
    fields.insert(QStringLiteral("progress"), double(m_progress));
    fields.insert(QStringLiteral("actions"), flatActions());
    // Hints that were removed must be cleared on the other side too
    fields.insert(QStringLiteral("replaceHints"), true);

    QDBusMessage msg = QDBusMessage::createMethodCall(s_service, s_path, s_interface, QStringLiteral("UpdateFields"));
    msg << m_id << fields;
    QDBusConnection::sessionBus().call(msg, QDBus::NoBlock);
}

void IslandActivity::finish(const QString &message)
{
    m_updateTimer.stop();
    if (!m_id)
        return;
    QDBusMessage msg = QDBusMessage::createMethodCall(s_service, s_path, s_interface, QStringLiteral("Finish"));
    msg << m_id << message;
    QDBusConnection::sessionBus().call(msg, QDBus::NoBlock);
    m_id = 0;
    emit activityIdChanged();
}

void IslandActivity::onActionInvoked(uint id, const QString &actionId)
{
    if (id && id == m_id)
        emit actionInvoked(actionId);
}

void IslandActivity::onActivityClosed(uint id)
{
    if (id && id == m_id) {
        m_id = 0;
        emit activityIdChanged();
    }
}
