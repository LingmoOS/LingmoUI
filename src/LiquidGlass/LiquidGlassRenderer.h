#pragma once

#include <QOpenGLBuffer>
#include <QOpenGLFramebufferObject>
#include <QOpenGLFunctions_3_3_Core>
#include <QOpenGLShaderProgram>
#include <QOpenGLTexture>
#include <QOpenGLVertexArrayObject>
#include <QQuickFramebufferObject>
#include <QString>
#include <memory>

#include "GLBlurPass.h"

class LiquidGlassController;
class LiquidGlassView;

class LiquidGlassRenderer : public QQuickFramebufferObject::Renderer, protected QOpenGLFunctions_3_3_Core {
public:
    LiquidGlassRenderer();
    ~LiquidGlassRenderer() override;

    void render() override;
    QOpenGLFramebufferObject* createFramebufferObject(const QSize& size) override;
    void synchronize(QQuickFramebufferObject* item) override;

private:
    void initialize();
    void ensureTextureLoaded();
    void ensureSceneTargets();
    void drawQuad(QOpenGLShaderProgram& program, GLuint texture);

    LiquidGlassController* m_controller = nullptr;
    bool m_initialized = false;
    QSize m_size;
    QString m_backgroundPath;
    int m_lastLoadedId = -1;
    QOpenGLShaderProgram m_backgroundProgram;
    QOpenGLShaderProgram m_glassProgram;
    QOpenGLVertexArrayObject m_vao;
    QOpenGLBuffer m_vbo { QOpenGLBuffer::VertexBuffer };
    std::unique_ptr<QOpenGLTexture> m_backgroundTexture;
    std::unique_ptr<QOpenGLFramebufferObject> m_sceneFbo;
    QOpenGLFramebufferObject* m_outputFbo = nullptr;
    GLBlurPass m_blur;
};
