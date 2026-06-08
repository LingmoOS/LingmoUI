#include "LiquidGlassView.h"
#include "LiquidGlassController.h"
#include "LiquidGlassRenderer.h"

LiquidGlassView::LiquidGlassView(QQuickItem* parent)
    : QQuickFramebufferObject(parent)
{
    setMirrorVertically(true);
}

QQuickFramebufferObject::Renderer* LiquidGlassView::createRenderer() const
{
    return new LiquidGlassRenderer();
}

void LiquidGlassView::setController(QObject* controller)
{
    if (m_controller == controller)
        return;
    if (m_controller)
        disconnect(m_controller, nullptr, this, nullptr);
    m_controller = controller;
    if (auto* glassController = qobject_cast<LiquidGlassController*>(m_controller)) {
        connect(glassController, &LiquidGlassController::paramsChanged, this, &QQuickItem::update);
        connect(glassController, &LiquidGlassController::mouseControlChanged, this, &QQuickItem::update);
        connect(glassController, &LiquidGlassController::glassPositionChanged, this, &QQuickItem::update);
        // sceneImageChanged comes from grabToImage callback (render thread);
        // the self-sustaining render()→update() loop picks up the new image automatically
    }
    emit controllerChanged();
    update();
}
