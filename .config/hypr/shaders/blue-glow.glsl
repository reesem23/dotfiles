// simple bloom / glow shader colored blue
uniform sampler2D tex;
uniform float exposure;
uniform float bloom_strength;

const vec3 tint = vec3(0.2, 0.5, 1.0); // blue glow color

vec4 hook() {
    vec2 uv = gl_FragCoord.xy / resolution;

    vec3 color = texture(tex, uv).rgb;

    // blur pass
    vec3 blur = vec3(0.0);
    float radius = 0.005;

    for (float x = -2.0; x <= 2.0; x++) {
        for (float y = -2.0; y <= 2.0; y++) {
            blur += texture(tex, uv + vec2(x, y) * radius).rgb;
        }
    }

    blur /= 25.0;

    // bloom + tint
    vec3 glow = blur * tint * bloom_strength;

    return vec4(color + glow, 1.0);
}
