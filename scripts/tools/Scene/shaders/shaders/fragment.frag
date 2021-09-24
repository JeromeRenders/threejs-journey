precision mediump float;

varying vec2 vUv;
varying float vRandom;

void main() {

    vec2 uv = vUv;
    vec4 color = vec4(0.5, vRandom, 1.0, 1.0);

    gl_FragColor = vec4(color);
}
