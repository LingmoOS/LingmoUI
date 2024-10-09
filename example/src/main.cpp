#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qlogging.h>
#include <qtenvironmentvariables.h>

int main(int argc, char* argv[])
{
    qDebug() << "LINGMOUI_TEMP_IMPORT_PATH: " << LINGMOUI_TEMP_IMPORT_PATH;
    QString path = QString(LINGMOUI_TEMP_IMPORT_PATH) + ":" + qgetenv("QML_IMPORT_PATH");
    qputenv("QML_IMPORT_PATH", path.toStdString().c_str());

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}