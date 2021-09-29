precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vRandom;
varying float vElevation;

void main() {

    vec4 color = texture2D(uTexture, vUv);
    color.rgb *= vElevation * 2.0 + 0.9;

    gl_FragColor = vec4(color);
}
