uniform float uBigWavesColorOffset;
uniform float uBigWavesColorMultiplier;
uniform vec3  uBigWavesColorSurface;
uniform vec3  uBigWavesColorDepth;

varying float vElevation;
varying vec2  vUv;

void main() {

    float mixStrengh = (vElevation + uBigWavesColorOffset) * uBigWavesColorMultiplier;
    vec3 color = mix(uBigWavesColorDepth, uBigWavesColorSurface, mixStrengh);

    gl_FragColor = vec4(color, 1.0);
}
