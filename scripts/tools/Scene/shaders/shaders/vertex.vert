attribute float aRandom;

varying vec2 vUv;
varying float vRandom;

void main() {
    vUv = uv;
    vRandom = aRandom;

    vec3 pos = position;
    // pos.z = sin(pos.x * 10.0) * 0.1;
    pos.z += aRandom * 0.1;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}