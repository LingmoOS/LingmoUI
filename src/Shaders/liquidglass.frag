#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 resolution;
    vec2 textureResolution;
    vec2 boundsPosition;
    vec2 boundsSize;
    float refraction;
    float bevelDepth;
    float bevelWidth;
    float frost;
    float radius;
    float time;
    float specular;
    float revealProgress;
    float magnify;
    float tiltX;
    float tiltY;
};

layout(binding = 1) uniform sampler2D source;

float udRoundBox(vec2 p, vec2 b, float r) {
    return length(max(abs(p) - b + r, vec2(0.0))) - r;
}

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float edgeFactor(vec2 uv, float radiusPx) {
    vec2 pPx = (uv - 0.5) * resolution;
    vec2 bPx = 0.5 * resolution;
    float d = -udRoundBox(pPx, bPx, radiusPx);
    float bevelPx = max(0.0001, bevelWidth * min(resolution.x, resolution.y));
    return 1.0 - smoothstep(0.0, bevelPx, d);
}

void main()
{
    vec2 p = qt_TexCoord0 - 0.5;
    p.x *= resolution.x / max(resolution.y, 1.0);

    float edge = edgeFactor(qt_TexCoord0, radius);
    float offsetAmt = (edge * refraction + pow(edge, 10.0) * bevelDepth);
    float centreBlend = smoothstep(0.15, 0.45, length(p));
    vec2 offset = normalize(p + vec2(0.0001)) * offsetAmt * centreBlend;

    float tiltScale = 0.05;
    vec2 tiltOffset = vec2(tan(radians(tiltY)), -tan(radians(tiltX))) * tiltScale;

    vec2 localUV = (qt_TexCoord0 - 0.5) / max(magnify, 0.001) + 0.5;
    vec2 flippedUV = vec2(localUV.x, 1.0 - localUV.y);
    vec2 mapped = boundsPosition + flippedUV * boundsSize;
    vec2 refracted = mapped + offset - tiltOffset;

    float oob = max(max(-refracted.x, refracted.x - 1.0), max(-refracted.y, refracted.y - 1.0));
    float blend = 1.0 - smoothstep(0.0, 0.01, oob);
    vec2 sampleUV = mix(mapped, refracted, blend);

    vec4 baseCol = texture(source, mapped);
    vec2 texel = 1.0 / max(textureResolution, vec2(1.0));
    vec4 refrCol;

    if (frost > 0.0) {
        float blurRadius = frost * 4.0;
        vec4 sum = vec4(0.0);
        const int SAMPLES = 16;
        for (int i = 0; i < SAMPLES; ++i) {
            float angle = random(qt_TexCoord0 + float(i)) * 6.283185;
            float dist = sqrt(random(qt_TexCoord0 - float(i))) * blurRadius;
            vec2 froff = vec2(cos(angle), sin(angle)) * texel * dist;
            sum += texture(source, clamp(sampleUV + froff, vec2(0.0), vec2(1.0)));
        }
        refrCol = sum / float(SAMPLES);
    } else {
        refrCol = texture(source, sampleUV);
        refrCol += texture(source, clamp(sampleUV + vec2(texel.x, 0.0), vec2(0.0), vec2(1.0)));
        refrCol += texture(source, clamp(sampleUV + vec2(-texel.x, 0.0), vec2(0.0), vec2(1.0)));
        refrCol += texture(source, clamp(sampleUV + vec2(0.0, texel.y), vec2(0.0), vec2(1.0)));
        refrCol += texture(source, clamp(sampleUV + vec2(0.0, -texel.y), vec2(0.0), vec2(1.0)));
        refrCol /= 5.0;
    }

    if (refrCol.a < 0.1) {
        refrCol = baseCol;
    }

    float diff = clamp(length(refrCol.rgb - baseCol.rgb) * 4.0, 0.0, 1.0);
    float antiHalo = (1.0 - centreBlend) * diff;

    vec4 finalCol = refrCol;
    finalCol.rgb = mix(finalCol.rgb, baseCol.rgb, antiHalo * 0.35);

    if (specular > 0.5) {
        vec2 lp1 = vec2(sin(time * 0.2), cos(time * 0.3)) * 0.6 + 0.5;
        vec2 lp2 = vec2(sin(time * -0.4 + 1.5), cos(time * 0.25 - 0.5)) * 0.6 + 0.5;
        float h = 0.0;
        h += smoothstep(0.4, 0.0, distance(qt_TexCoord0, lp1)) * 0.1;
        h += smoothstep(0.5, 0.0, distance(qt_TexCoord0, lp2)) * 0.08;
        finalCol.rgb += h;
    }

    vec2 pPx = (qt_TexCoord0 - 0.5) * resolution;
    vec2 bPx = 0.5 * resolution;
    float dmask = udRoundBox(pPx, bPx, radius);
    float inShape = 1.0 - step(0.0, dmask);

    if (revealProgress < 1.0) {
        finalCol.rgb *= revealProgress;
        finalCol.a *= revealProgress;
    }

    finalCol.rgb *= inShape;
    finalCol.a *= inShape;

    fragColor = finalCol * qt_Opacity;
}
