#include "LiquidGlassRenderer.h"

#include <QImage>
#include <QOpenGLFramebufferObjectFormat>
#include <QQuickFramebufferObject>
#include <QtGlobal>

#include "LiquidGlassController.h"
#include "LiquidGlassView.h"

LiquidGlassRenderer::LiquidGlassRenderer() = default;
LiquidGlassRenderer::~LiquidGlassRenderer() = default;

void LiquidGlassRenderer::initialize()
{
    if (m_initialized)
        return;

    initializeOpenGLFunctions();

    m_backgroundProgram.addShaderFromSourceCode(QOpenGLShader::Vertex, R"(
        #version 330 core
        layout(location = 0) in vec2 aPosition;
        layout(location = 1) in vec2 aTexCoord;
        out vec2 vTexCoord;
        void main() { gl_Position = vec4(aPosition, 0.0, 1.0); vTexCoord = aTexCoord; }
    )");
    m_backgroundProgram.addShaderFromSourceCode(QOpenGLShader::Fragment, R"(
        #version 330 core
        in vec2 vTexCoord;
        out vec4 fragColor;
        uniform sampler2D uTexture;
        void main() { fragColor = texture(uTexture, vTexCoord); }
    )");
    m_backgroundProgram.link();

    m_glassProgram.addShaderFromSourceCode(QOpenGLShader::Vertex, R"(
        #version 330 core
        layout(location = 0) in vec2 aPosition;
        layout(location = 1) in vec2 aTexCoord;
        out vec2 vTexCoord;
        void main() { gl_Position = vec4(aPosition, 0.0, 1.0); vTexCoord = aTexCoord; }
    )");
    m_glassProgram.addShaderFromSourceCode(QOpenGLShader::Fragment, R"(
        #version 330 core
        in vec2 vTexCoord;
        out vec4 fragColor;
        uniform sampler2D u_Background;
        uniform sampler2D u_Blur;
        uniform vec2 u_Resolution;
        uniform float u_powerFactor;
        uniform float u_a;
        uniform float u_b;
        uniform float u_c;
        uniform float u_d;
        uniform float u_fPower;
        uniform float u_noise;
        uniform float u_glowWeight;
        uniform float u_glowBias;
        uniform float u_glowEdge0;
        uniform float u_glowEdge1;
        uniform vec2 u_GlassCenter;
        uniform vec2 u_GlassSize;
        float rand(vec2 co){ return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453); }
        float f(float x) { return 1.0 - u_b * pow(u_c * 2.718281828459045, -u_d * x - u_a); }
        float sdSuperellipse(vec2 p, float n, float r) {
            vec2 p_abs = abs(p);
            float numerator = pow(p_abs.x, n) + pow(p_abs.y, n) - pow(r, n);
            float denominator = n * sqrt(pow(p_abs.x, 2.0 * n - 2.0) + pow(p_abs.y, 2.0 * n - 2.0)) + 0.00001;
            return numerator / denominator;
        }
        float Glow(vec2 p) { return sin(atan(p.y, p.x) - 0.5); }
        void main() {
            vec2 screenUv = gl_FragCoord.xy / u_Resolution;
            vec2 p = (screenUv - u_GlassCenter) / u_GlassSize;
            float d = sdSuperellipse(p, u_powerFactor, 1.0);
            if (d > 0.0) discard;
            float dist = -d;
            vec2 sampleP = p * pow(f(dist), u_fPower);
            vec2 coord = u_GlassCenter + sampleP * u_GlassSize;
            vec4 noise = vec4(vec3(rand(gl_FragCoord.xy * 1e-3) - 0.5), 0.0);
            vec4 color = texture(u_Blur, clamp(coord, vec2(0.0), vec2(1.0))) + noise * u_noise;
            float mul = Glow(p) * u_glowWeight * smoothstep(u_glowEdge0, u_glowEdge1, dist) + 1.0 + u_glowBias;
            fragColor = color * vec4(vec3(mul), 1.0);
        }
    )");
    m_glassProgram.link();

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
    m_backgroundProgram.bind();
    m_backgroundProgram.enableAttributeArray(0);
    m_backgroundProgram.enableAttributeArray(1);
    m_backgroundProgram.setAttributeBuffer(0, GL_FLOAT, 0, 2, 4 * sizeof(float));
    m_backgroundProgram.setAttributeBuffer(1, GL_FLOAT, 2 * sizeof(float), 2, 4 * sizeof(float));
    m_glassProgram.bind();
    m_glassProgram.enableAttributeArray(0);
    m_glassProgram.enableAttributeArray(1);
    m_glassProgram.setAttributeBuffer(0, GL_FLOAT, 0, 2, 4 * sizeof(float));
    m_glassProgram.setAttributeBuffer(1, GL_FLOAT, 2 * sizeof(float), 2, 4 * sizeof(float));
    m_glassProgram.release();
    m_vbo.release();
    m_vao.release();

    m_blur.initialize();
    m_initialized = true;
}

void LiquidGlassRenderer::ensureTextureLoaded()
{
    if (!m_controller || m_backgroundPath.isEmpty())
        return;
    if (m_backgroundTexture && m_lastLoadedId == m_controller->backgroundId())
        return;

    const QImage image(m_backgroundPath);
    if (image.isNull()) {
        m_backgroundTexture.reset();
        return;
    }

    m_backgroundTexture = std::make_unique<QOpenGLTexture>(image.mirrored());
    m_backgroundTexture->setMinificationFilter(QOpenGLTexture::LinearMipMapLinear);
    m_backgroundTexture->setMagnificationFilter(QOpenGLTexture::Linear);
    m_backgroundTexture->setWrapMode(QOpenGLTexture::ClampToEdge);
    m_lastLoadedId = m_controller->backgroundId();
}

void LiquidGlassRenderer::ensureSceneTargets()
{
    if (m_size.isEmpty())
        return;
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    if (!m_sceneFbo || m_sceneFbo->size() != m_size)
        m_sceneFbo = std::make_unique<QOpenGLFramebufferObject>(m_size, format);
}

QOpenGLFramebufferObject* LiquidGlassRenderer::createFramebufferObject(const QSize& size)
{
    m_size = size;
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    m_outputFbo = new QOpenGLFramebufferObject(size, format);
    return m_outputFbo;
}

void LiquidGlassRenderer::synchronize(QQuickFramebufferObject* item)
{
    m_controller = static_cast<LiquidGlassView*>(item)->controller()
        ? qobject_cast<LiquidGlassController*>(static_cast<LiquidGlassView*>(item)->controller())
        : nullptr;
    if (!m_controller)
        return;

    m_backgroundPath = m_controller->backgroundSource();
}

void LiquidGlassRenderer::drawQuad(QOpenGLShaderProgram& program, GLuint texture)
{
    if (texture) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture);
    }
    m_vao.bind();
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    m_vao.release();
    program.release();
}

void LiquidGlassRenderer::render()
{
    initialize();
    ensureTextureLoaded();
    ensureSceneTargets();

    glDisable(GL_DEPTH_TEST);

    if (m_sceneFbo && m_backgroundTexture) {
        m_sceneFbo->bind();
        glViewport(0, 0, m_sceneFbo->width(), m_sceneFbo->height());
        glClearColor(0.08f, 0.08f, 0.08f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        m_backgroundProgram.bind();
        m_backgroundProgram.setUniformValue("uTexture", 0);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, m_backgroundTexture->textureId());
        m_vao.bind();
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        m_vao.release();
        m_backgroundProgram.release();
        m_sceneFbo->release();
    }

    if (m_sceneFbo) {
        const float blurScale = m_controller ? m_controller->blurDownscaleFactor() : 0.5f;
        const QSize blurSize(
            qMax(1, int(float(m_sceneFbo->width()) * blurScale)),
            qMax(1, int(float(m_sceneFbo->height()) * blurScale))
        );
        m_blur.resize(blurSize);
        m_blur.run(m_sceneFbo->texture(),
                   m_controller ? m_controller->blurIters() : 1,
                   m_controller ? m_controller->blurRadius() : 2.0f);
    }

    if (!m_outputFbo)
        return;

    m_outputFbo->bind();
    glViewport(0, 0, m_outputFbo->width(), m_outputFbo->height());
    glClearColor(0.08f, 0.08f, 0.08f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    if (m_sceneFbo) {
        m_backgroundProgram.bind();
        m_backgroundProgram.setUniformValue("uTexture", 0);
        drawQuad(m_backgroundProgram, m_sceneFbo->texture());
    }

    if (m_controller && m_sceneFbo && m_blur.outputTexture()) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        m_glassProgram.bind();
        m_glassProgram.setUniformValue("u_Background", 0);
        m_glassProgram.setUniformValue("u_Blur", 1);
        m_glassProgram.setUniformValue("u_Resolution",
            QVector2D(float(m_outputFbo->width()), float(m_outputFbo->height())));
        m_glassProgram.setUniformValue("u_powerFactor", m_controller->powerFactor());
        m_glassProgram.setUniformValue("u_a", m_controller->a());
        m_glassProgram.setUniformValue("u_b", m_controller->b());
        m_glassProgram.setUniformValue("u_c", m_controller->c());
        m_glassProgram.setUniformValue("u_d", m_controller->d());
        m_glassProgram.setUniformValue("u_fPower", m_controller->fPower());
        m_glassProgram.setUniformValue("u_noise", m_controller->noise());
        m_glassProgram.setUniformValue("u_glowWeight", m_controller->glowWeight());
        m_glassProgram.setUniformValue("u_glowBias", m_controller->glowBias());
        m_glassProgram.setUniformValue("u_glowEdge0", m_controller->glowEdge0());
        m_glassProgram.setUniformValue("u_glowEdge1", m_controller->glowEdge1());
        const float widthNorm = 0.08f * m_controller->glassWidth();
        const float heightNorm = 0.08f * m_controller->glassHeight();
        const QVector2D glassCenter(
            m_controller->mouseControl() ? m_controller->glassX() : 0.5f,
            m_controller->mouseControl() ? (1.0f - m_controller->glassY()) : 0.5f
        );
        m_glassProgram.setUniformValue("u_GlassCenter", glassCenter);
        m_glassProgram.setUniformValue("u_GlassSize", QVector2D(widthNorm, heightNorm));
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, m_sceneFbo->texture());
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, m_blur.outputTexture());
        m_vao.bind();
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        m_vao.release();
        m_glassProgram.release();
        glDisable(GL_BLEND);
    }

    m_outputFbo->release();
    update();
}
