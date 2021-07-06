#ifdef GL_ES
precision highp float;
#endif

varying vec2 vUv;

uniform float uTime;
uniform float uProgress;


void main() {

    vec4 color = vec4(vUv.x, vUv.y, 0.0, 1.0);
    gl_FragColor = color;
}