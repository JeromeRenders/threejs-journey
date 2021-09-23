#ifdef GL_ES
precision highp float;
#endif

varying vec2 vUv;

void main() {

    vec2 uv = vUv;
    vec4 color = vec4(uv.x, uv.y, 0.0, 1.0);

    gl_FragColor = vec4(color);
}
