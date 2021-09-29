attribute float aRandom;

uniform float uTime;
uniform vec2 uFrequency;

varying vec2 vUv;
varying float vRandom;
varying float vElevation;

void main() {

    vec3 pos = position;

    float elevation = sin(pos.x * uFrequency.x - uTime) * 0.1;
    elevation += sin(pos.y * uFrequency.y - uTime) * 0.1;

    pos.z += elevation;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vUv = uv;
    vRandom = aRandom;
    vElevation = elevation;
}