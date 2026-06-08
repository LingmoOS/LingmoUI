#pragma once

#include <QOpenGLBuffer>
#include <QOpenGLFramebufferObject>
#include <QOpenGLFunctions_3_3_Core>
#include <QOpenGLShaderProgram>
#include <QOpenGLVertexArrayObject>
#include <QSize>
#include <memory>

class GLBlurPass : protected QOpenGLFunctions_3_3_Core {
public:
    void initialize();
    void resize(const QSize& size);
    void run(GLuint inputTexture, int iterations, float radius);
    GLuint outputTexture() const;

private:
    void ensureResources();
    void drawPass(GLuint inputTexture, QOpenGLFramebufferObject* target, const QVector2D& direction, float radius);

    QOpenGLShaderProgram m_program;
    QOpenGLVertexArrayObject m_vao;
    QOpenGLBuffer m_vbo { QOpenGLBuffer::VertexBuffer };
    std::unique_ptr<QOpenGLFramebufferObject> m_ping;
    std::unique_ptr<QOpenGLFramebufferObject> m_pong;
    QSize m_size;
    bool m_initialized = false;
};
