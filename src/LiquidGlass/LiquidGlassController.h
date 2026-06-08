#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqml.h>

class LiquidGlassController : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(LiquidGlassController)
    Q_PROPERTY(QString backgroundSource READ backgroundSource WRITE setBackgroundSource NOTIFY backgroundSourceChanged)
    Q_PROPERTY(int backgroundId READ backgroundId NOTIFY backgroundIdChanged)
    Q_PROPERTY(bool mouseControl READ mouseControl WRITE setMouseControl NOTIFY mouseControlChanged)
    Q_PROPERTY(float powerFactor READ powerFactor WRITE setPowerFactor NOTIFY paramsChanged)
    Q_PROPERTY(float a READ a WRITE setA NOTIFY paramsChanged)
    Q_PROPERTY(float b READ b WRITE setB NOTIFY paramsChanged)
    Q_PROPERTY(float c READ c WRITE setC NOTIFY paramsChanged)
    Q_PROPERTY(float d READ d WRITE setD NOTIFY paramsChanged)
    Q_PROPERTY(float fPower READ fPower WRITE setFPower NOTIFY paramsChanged)
    Q_PROPERTY(float noise READ noise WRITE setNoise NOTIFY paramsChanged)
    Q_PROPERTY(float glowWeight READ glowWeight WRITE setGlowWeight NOTIFY paramsChanged)
    Q_PROPERTY(float glowBias READ glowBias WRITE setGlowBias NOTIFY paramsChanged)
    Q_PROPERTY(float glowEdge0 READ glowEdge0 WRITE setGlowEdge0 NOTIFY paramsChanged)
    Q_PROPERTY(float glowEdge1 READ glowEdge1 WRITE setGlowEdge1 NOTIFY paramsChanged)
    Q_PROPERTY(float blurRadius READ blurRadius WRITE setBlurRadius NOTIFY paramsChanged)
    Q_PROPERTY(int blurIters READ blurIters WRITE setBlurIters NOTIFY paramsChanged)
    Q_PROPERTY(float blurDownscaleFactor READ blurDownscaleFactor WRITE setBlurDownscaleFactor NOTIFY paramsChanged)
    Q_PROPERTY(float glassWidth READ glassWidth WRITE setGlassWidth NOTIFY paramsChanged)
    Q_PROPERTY(float glassHeight READ glassHeight WRITE setGlassHeight NOTIFY paramsChanged)
    Q_PROPERTY(float glassX READ glassX NOTIFY glassPositionChanged)
    Q_PROPERTY(float glassY READ glassY NOTIFY glassPositionChanged)

public:
    explicit LiquidGlassController(QObject* parent = nullptr);

    QString backgroundSource() const { return m_backgroundSource; }
    int backgroundId() const { return m_backgroundId; }
    bool mouseControl() const { return m_mouseControl; }
    float powerFactor() const { return m_powerFactor; }
    float a() const { return m_a; }
    float b() const { return m_b; }
    float c() const { return m_c; }
    float d() const { return m_d; }
    float fPower() const { return m_fPower; }
    float noise() const { return m_noise; }
    float glowWeight() const { return m_glowWeight; }
    float glowBias() const { return m_glowBias; }
    float glowEdge0() const { return m_glowEdge0; }
    float glowEdge1() const { return m_glowEdge1; }
    float blurRadius() const { return m_blurRadius; }
    int blurIters() const { return m_blurIters; }
    float blurDownscaleFactor() const { return m_blurDownscaleFactor; }
    float glassWidth() const { return m_glassWidth; }
    float glassHeight() const { return m_glassHeight; }
    float glassX() const { return m_glassX; }
    float glassY() const { return m_glassY; }

public slots:
    void setBackgroundSource(const QString& value);
    void setMouseControl(bool value);
    void setPowerFactor(float value);
    void setA(float value);
    void setB(float value);
    void setC(float value);
    void setD(float value);
    void setFPower(float value);
    void setNoise(float value);
    void setGlowWeight(float value);
    void setGlowBias(float value);
    void setGlowEdge0(float value);
    void setGlowEdge1(float value);
    void setBlurRadius(float value);
    void setBlurIters(int value);
    void setBlurDownscaleFactor(float value);
    void setGlassWidth(float value);
    void setGlassHeight(float value);
    Q_INVOKABLE void setMousePosition(float x, float y);

signals:
    void backgroundSourceChanged();
    void backgroundIdChanged();
    void mouseControlChanged();
    void paramsChanged();
    void glassPositionChanged();

private:
    QString m_backgroundSource;
    int m_backgroundId = 0;
    bool m_mouseControl = false;
    float m_powerFactor = 3.0f;
    float m_a = 0.7f;
    float m_b = 2.3f;
    float m_c = 5.2f;
    float m_d = 6.9f;
    float m_fPower = 1.0f;
    float m_noise = 0.06f;
    float m_glowWeight = 0.25f;
    float m_glowBias = 0.0f;
    float m_glowEdge0 = 0.5f;
    float m_glowEdge1 = -0.5f;
    float m_blurRadius = 2.0f;
    int m_blurIters = 1;
    float m_blurDownscaleFactor = 0.5f;
    float m_glassWidth = 3.5f;
    float m_glassHeight = 3.5f;
    float m_glassX = 0.5f;
    float m_glassY = 0.5f;
};
