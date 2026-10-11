#version 300 es
// Night light: cut blue, soften green -> warm yellow tint (~3500K)
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 c = texture(tex, v_texcoord);
    fragColor = vec4(c.r, c.g * 0.82, c.b * 0.55, c.a);
}
