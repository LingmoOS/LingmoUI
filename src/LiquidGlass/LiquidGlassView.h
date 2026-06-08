#pragma once

#include <QQuickFramebufferObject>

class LiquidGlassController;

class LiquidGlassView : public QQuickFramebufferObject {
    Q_OBJECT
    Q_PROPERTY(QObject* controller READ controller WRITE setController NOTIFY controllerChanged)
    QML_NAMED_ELEMENT(LiquidGlassView)

public:
    explicit LiquidGlassView(QQuickItem* parent = nullptr);
    Renderer* createRenderer() const override;

    QObject* controller() const { return m_controller; }
    void setController(QObject* controller);

signals:
    void controllerChanged();

private:
    QObject* m_controller = nullptr;
};
