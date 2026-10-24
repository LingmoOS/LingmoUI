/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef ISLANDACTIVITY_H
#define ISLANDACTIVITY_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlParserStatus>
#include <QTimer>
#include <QVariant>

class QDBusServiceWatcher;

/*
 * IslandActivity: a live activity in the status bar's Island
 * (com.lingmo.Island, see docs/island-api.md), declared from QML:
 *
 *   LingmoUI.IslandActivity {
 *       active: timer.running
 *       kind: "timer"
 *       title: qsTr("Timer")
 *       subtitle: timer.remainingText
 *       iconName: "chronometer"
 *       hints: ({ endTime: timer.deadline, paused: timer.paused })
 *       actions: [ { id: "pause", label: qsTr("Pause") }, { id: "stop", label: qsTr("Stop") } ]
 *       onActionInvoked: (actionId) => ...
 *   }
 *
 * It starts the activity when active becomes true, sends updates when the
 * properties change (coalesced), and finishes it with finishMessage when
 * active becomes false. If the status bar restarts the activity is started
 * again. Without a status bar nothing happens.
 */
class IslandActivity : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(IslandActivity)

    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(QString appId READ appId WRITE setAppId NOTIFY changed)
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY changed)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY changed)
    Q_PROPERTY(QString subtitle READ subtitle WRITE setSubtitle NOTIFY changed)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY changed)
    // 0..1, or -1 for none
    Q_PROPERTY(qreal progress READ progress WRITE setProgress NOTIFY changed)
    // [ { id: "stop", label: "Stop" }, ... ] or [ "stop", "Stop", ... ]
    Q_PROPERTY(QVariantList actions READ actions WRITE setActions NOTIFY changed)
    // startTime / endTime (ms since epoch), paused, artUrl, accent, ...
    Q_PROPERTY(QVariantMap hints READ hints WRITE setHints NOTIFY changed)
    // Shown for a moment when the activity ends (empty: it just goes away)
    Q_PROPERTY(QString finishMessage READ finishMessage WRITE setFinishMessage NOTIFY changed)
    // Id given by the status bar (0 while not running)
    Q_PROPERTY(uint activityId READ activityId NOTIFY activityIdChanged)

public:
    explicit IslandActivity(QObject *parent = nullptr);
    ~IslandActivity() override;

    void classBegin() override {}
    void componentComplete() override;

    bool active() const { return m_active; }
    void setActive(bool active);

    QString appId() const { return m_appId; }
    void setAppId(const QString &v);
    QString kind() const { return m_kind; }
    void setKind(const QString &v);
    QString title() const { return m_title; }
    void setTitle(const QString &v);
    QString subtitle() const { return m_subtitle; }
    void setSubtitle(const QString &v);
    QString iconName() const { return m_iconName; }
    void setIconName(const QString &v);
    qreal progress() const { return m_progress; }
    void setProgress(qreal v);
    QVariantList actions() const { return m_actions; }
    void setActions(const QVariantList &v);
    QVariantMap hints() const { return m_hints; }
    void setHints(const QVariantMap &v);
    QString finishMessage() const { return m_finishMessage; }
    void setFinishMessage(const QString &v);
    uint activityId() const { return m_id; }

    // Ends the activity now with this message (active stays as it is)
    Q_INVOKABLE void finish(const QString &message);

signals:
    void activeChanged();
    void changed();
    void activityIdChanged();
    void actionInvoked(const QString &actionId);

private slots:
    void onActionInvoked(uint id, const QString &actionId);
    void onActivityClosed(uint id);

private:
    QStringList flatActions() const;
    void start();
    void sendUpdate();
    void scheduleUpdate();

    bool m_complete = false;
    bool m_active = false;
    QString m_appId;
    QString m_kind = QStringLiteral("generic");
    QString m_title;
    QString m_subtitle;
    QString m_iconName;
    qreal m_progress = -1;
    QVariantList m_actions;
    QVariantMap m_hints;
    QString m_finishMessage;
    uint m_id = 0;
    bool m_starting = false;
    bool m_dirty = false;
    QTimer m_updateTimer;
    QDBusServiceWatcher *m_watcher = nullptr;
};

#endif
