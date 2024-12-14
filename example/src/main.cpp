#include <QApplication>
#include <QMessageBox>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <qlogging.h>
#include <qqmlcontext.h>
#include <qtenvironmentvariables.h>

class AboutQtController : public QObject {
    Q_OBJECT
public:
    AboutQtController(QObject* parent = nullptr)
        : QObject { parent }
    {
    }
signals:
    void showAboutQt();
public slots:
    void showAboutQtDialog()
    {
        QMessageBox::aboutQt(nullptr, "About Qt");
    }
};

int main(int argc, char* argv[])
{
    qDebug() << "LINGMOUI_TEMP_IMPORT_PATH: " << LINGMOUI_TEMP_IMPORT_PATH;
    QString path = QString(LINGMOUI_TEMP_IMPORT_PATH) + ":" + qgetenv("QML_IMPORT_PATH");
    qputenv("QML_IMPORT_PATH", path.toStdString().c_str());

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // 创建 AboutQtController 对象
    AboutQtController aboutQtController(&app);

    // 将 aboutQtController 注册到 QML 上下文中
    engine.rootContext()->setContextProperty("aboutQtController", &aboutQtController);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

#include "main.moc"
