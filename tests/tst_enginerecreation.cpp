/*
 * SPDX-FileCopyrightText: 2026 LingmoOS Team
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// One QML engine is destroyed and another one is created in the same process,
// twice, each time using LingmoUI's singletons (LingmoTheme, LingmoColor,
// LingmoApp... through QtQuick.Controls.LingmoStyle, and the
// CompatibleModule's Theme, Units and ThemeManager), the icon item, the wheel
// handler and the shared controls. The C++ singletons are process-wide: an
// engine must not delete them when it goes away.

#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickItem>
#include <QQuickWindow>
#include <QScopedPointer>
#include <QtTest>

static const char *s_qml = R"(
import QtQuick
import QtQuick.Controls
import LingmoUI as Core
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    width: 400
    height: 300
    visible: true
    property bool dark: LingmoUI.Theme.darkMode
    property real spacing: LingmoUI.Units.largeSpacing
    property color accent: LingmoUI.Theme.highlightColor
    property bool coreDark: Core.LingmoTheme.dark
    property color coreColor: Core.LingmoColor.Grey100

    ListView {
        id: list
        anchors.fill: parent
        model: 30
        delegate: LingmoUI.SideBarItem { title: "Item " + index; iconName: "folder"; width: 200 }
        LingmoUI.WheelHandler { target: list }
    }
    LingmoUI.IconItem { width: 16; height: 16; source: "folder" }
    LingmoUI.ActionButton { text: "Ok"; primary: true }
    LingmoUI.SegmentedControl { model: ["A", "B"] }
    Button { text: "Button" }
    Label { text: "Label" }
    Switch {}
    ScrollBar {}
}
)";

class TestEngineRecreation : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase()
    {
        // The style the Lingmo platform theme picks for every app
        if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE"))
            qputenv("QT_QUICK_CONTROLS_STYLE", "QtQuick.Controls.LingmoStyle");
    }

    void createAndDestroy_data()
    {
        QTest::addColumn<int>("round");
        QTest::newRow("first engine") << 1;
        QTest::newRow("second engine") << 2;
        QTest::newRow("third engine") << 3;
    }

    void createAndDestroy()
    {
        QFETCH(int, round);
        Q_UNUSED(round)

        QScopedPointer<QQmlEngine> engine(new QQmlEngine);
        QQmlComponent component(engine.data());
        component.setData(s_qml, QUrl(QStringLiteral("file:///tst_enginerecreation.qml")));
        QVERIFY2(component.isReady(), qPrintable(component.errorString()));

        QScopedPointer<QObject> object(component.create());
        QVERIFY2(object, qPrintable(component.errorString()));
        QCOMPARE(object->property("spacing").toReal(), 12.0);
        QVERIFY(object->property("accent").value<QColor>().isValid());
        QVERIFY(object->property("coreColor").value<QColor>().isValid());

        auto *window = qobject_cast<QQuickWindow *>(object.data());
        QVERIFY(window);
        QVERIFY(QTest::qWaitForWindowExposed(window));
        QTest::qWait(50);

        // The window (and its items) go first, then the engine
        object.reset();
        QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
        engine.reset();
        QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    }
};

QTEST_MAIN(TestEngineRecreation)
#include "tst_enginerecreation.moc"
