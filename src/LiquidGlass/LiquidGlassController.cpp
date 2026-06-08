#include "LiquidGlassController.h"

LiquidGlassController::LiquidGlassController(QObject* parent)
    : QObject(parent)
{
}

void LiquidGlassController::setBackgroundSource(const QString& value)
{
    if (m_backgroundSource == value)
        return;
    m_backgroundSource = value;
    m_backgroundId++;
    emit backgroundSourceChanged();
    emit backgroundIdChanged();
    emit paramsChanged();
}

void LiquidGlassController::setMouseControl(bool value)
{
    if (m_mouseControl == value)
        return;
    m_mouseControl = value;
    emit mouseControlChanged();
    emit paramsChanged();
}

void LiquidGlassController::setPowerFactor(float value) { m_powerFactor = value; emit paramsChanged(); }
void LiquidGlassController::setA(float value) { m_a = value; emit paramsChanged(); }
void LiquidGlassController::setB(float value) { m_b = value; emit paramsChanged(); }
void LiquidGlassController::setC(float value) { m_c = value; emit paramsChanged(); }
void LiquidGlassController::setD(float value) { m_d = value; emit paramsChanged(); }
void LiquidGlassController::setFPower(float value) { m_fPower = value; emit paramsChanged(); }
void LiquidGlassController::setNoise(float value) { m_noise = value; emit paramsChanged(); }
void LiquidGlassController::setGlowWeight(float value) { m_glowWeight = value; emit paramsChanged(); }
void LiquidGlassController::setGlowBias(float value) { m_glowBias = value; emit paramsChanged(); }
void LiquidGlassController::setGlowEdge0(float value) { m_glowEdge0 = value; emit paramsChanged(); }
void LiquidGlassController::setGlowEdge1(float value) { m_glowEdge1 = value; emit paramsChanged(); }
void LiquidGlassController::setBlurRadius(float value) { m_blurRadius = value; emit paramsChanged(); }
void LiquidGlassController::setBlurIters(int value) { m_blurIters = value; emit paramsChanged(); }
void LiquidGlassController::setBlurDownscaleFactor(float value) { m_blurDownscaleFactor = value; emit paramsChanged(); }
void LiquidGlassController::setGlassWidth(float value) { m_glassWidth = value; emit paramsChanged(); }
void LiquidGlassController::setGlassHeight(float value) { m_glassHeight = value; emit paramsChanged(); }

void LiquidGlassController::setMousePosition(float x, float y)
{
    const float clampedX = qBound(0.0f, x, 1.0f);
    const float clampedY = qBound(0.0f, y, 1.0f);
    if (m_glassX == clampedX && m_glassY == clampedY)
        return;
    m_glassX = clampedX;
    m_glassY = clampedY;
    emit glassPositionChanged();
    if (m_mouseControl)
        emit paramsChanged();
}
