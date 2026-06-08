#include "GLBlurPass.h"

#include <QOpenGLFramebufferObjectFormat>
#include <QOpenGLShader>
#include <QVector2D>

void GLBlurPass::initialize()
{
    if (m_initialized)
        return;
    initializeOpenGLFunctions();

    m_program.addShaderFromSourceCode(QOpenGLShader::Vertex, R"(
        #version 330 core
        layout(location = 0) in vec2 aPos;
        layout(location = 1) in vec2 aUv;
        out vec2 vUv;
        void main() { vUv = aUv; gl_Position = vec4(aPos, 0.0, 1.0); }
    )");
    m_program.addShaderFromSourceCode(QOpenGLShader::Fragment, R"(
        #version 330 core
        in vec2 vUv;
        out vec4 fragColor;
        uniform sampler2D u_in;
        uniform vec2 u_direction;
        uniform vec2 u_resolution;
        uniform float u_radius;
        vec4 blur13(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
            vec4 color = vec4(0.0);
            vec2 off1 = vec2(1.411764705882353) * direction;
            vec2 off2 = vec2(3.2941176470588234) * direction;
            vec2 off3 = vec2(5.176470588235294) * direction;
            color += texture(image, uv) * 0.1964825501511404;
            color += texture(image, uv + (off1 / resolution)) * 0.2969069646728344;
            color += texture(image, uv - (off1 / resolution)) * 0.2969069646728344;
            color += texture(image, uv + (off2 / resolution)) * 0.09447039785044732;
            color += texture(image, uv - (off2 / resolution)) * 0.09447039785044732;
            color += texture(image, uv + (off3 / resolution)) * 0.010381362401148057;
            color += texture(image, uv - (off3 / resolution)) * 0.010381362401148057;
            return color;
        }
        void main() { fragColor = blur13(u_in, vUv, u_resolution, u_direction * u_radius); }
    )");
    m_program.link();

    m_vao.create();
    m_vao.bind();
    m_vbo.create();
    m_vbo.bind();
    const float vertices[] = {
        -1.f, -1.f, 0.f, 0.f,
         1.f, -1.f, 1.f, 0.f,
        -1.f,  1.f, 0.f, 1.f,
         1.f,  1.f, 1.f, 1.f,
    };
    m_vbo.allocate(vertices, sizeof(vertices));
    m_program.enableAttributeArray(0);
    m_program.enableAttributeArray(1);
    m_program.setAttributeBuffer(0, GL_FLOAT, 0, 2, 4 * sizeof(float));
    m_program.setAttributeBuffer(1, GL_FLOAT, 2 * sizeof(float), 2, 4 * sizeof(float));
    m_vbo.release();
    m_vao.release();

    m_initialized = true;
}

void GLBlurPass::resize(const QSize& size)
{
    m_size = size;
    m_ping.reset();
    m_pong.reset();
}

void GLBlurPass::ensureResources()
{
    if (m_size.isEmpty() || m_ping)
        return;
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::NoAttachment);
    format.setInternalTextureFormat(GL_RGBA8);
    m_ping = std::make_unique<QOpenGLFramebufferObject>(m_size, format);
    m_pong = std::make_unique<QOpenGLFramebufferObject>(m_size, format);
}

void GLBlurPass::drawPass(GLuint inputTexture, QOpenGLFramebufferObject* target, const QVector2D& direction, float radius)
{
    if (!target)
        return;
    target->bind();
    glViewport(0, 0, target->width(), target->height());
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    m_program.bind();
    m_program.setUniformValue("u_in", 0);
    m_program.setUniformValue("u_resolution", QVector2D(float(target->width()), float(target->height())));
    m_program.setUniformValue("u_direction", direction);
    m_program.setUniformValue("u_radius", radius);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, inputTexture);
    m_vao.bind();
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    m_vao.release();
    target->release();
}

GLuint GLBlurPass::outputTexture() const
{
    return m_pong ? m_pong->texture() : 0;
}

void GLBlurPass::run(GLuint inputTexture, int iterations, float radius)
{
    if (!m_initialized || !inputTexture || m_size.isEmpty())
        return;
    ensureResources();
    if (!m_ping || !m_pong)
        return;

    GLuint source = inputTexture;
    for (int i = 0; i < qMax(1, iterations); ++i) {
        drawPass(source, m_ping.get(), QVector2D(1.f, 0.f), radius);
        drawPass(m_ping->texture(), m_pong.get(), QVector2D(0.f, 1.f), radius);
        source = m_pong->texture();
    }
}
