precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;

void main() {

    float strength = step(0.8, mod(vUv.y * 10.0, 1.0));
    strength *= step(0.8, mod(vUv.x * 10.0, 1.0));

    // 31:06


    gl_FragColor = vec4(vec3(strength), 1.0);
}
