#pragma glslify: cnoise3 = require('glsl-noise/classic/3d')

uniform float uTime;

uniform float uSmallWavesSpeed;
uniform float uSmallWavesElevation;
uniform float uSmallWavesFrequency;
uniform float uSmallWavesIterations;

uniform float uBigWavesSpeed;
uniform float uBigWavesElevation;
uniform vec2  uBigWavesFrequency;

varying float vElevation;
varying vec2 vUv;

void main() {

    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // Elevation
    float elevation = sin(modelPosition.x * uBigWavesFrequency.x + uTime * uBigWavesSpeed) *
                      sin(modelPosition.z * uBigWavesFrequency.y + uTime * uBigWavesSpeed) *
                      uBigWavesElevation;

    // Add the small waves
    for (float i = 1.0; i <= uSmallWavesIterations; i++) {
        elevation -= abs(
            cnoise3(
                vec3(
                    modelPosition.xz * uSmallWavesFrequency * i,
                    uTime * uSmallWavesSpeed
                )
            ) * uSmallWavesElevation / i
        );
    }

    modelPosition.y += elevation;

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    vUv = uv;
    vElevation = elevation;
}