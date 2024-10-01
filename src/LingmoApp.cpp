#include <QGuiApplication>

#include "LingmoApp.h"

LingmoApp::LingmoApp(QObject* parent)
    : QObject { parent }
{
}

void LingmoApp::init(QObject* launcher, QLocale locale)
{
    this->launcher(launcher);

    _locale = std::move(locale);
    _engine = qmlEngine(launcher);
    _translator = new QTranslator(this);

    QGuiApplication::installTranslator(_translator);

    const QStringList uiLanguages = _locale.uiLanguages();

    for (const QString& name : uiLanguages) {
        const QString baseName = "lingmoui_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/LingmoUI/i18n/" + baseName)) {
            _engine->retranslate();
            break;
        }
    }
}
