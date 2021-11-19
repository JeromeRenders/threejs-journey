#pragma glslify: cnoise = require('glsl-noise/classic/2d')

uniform float uTime;
uniform float uPattern;

varying vec2 vUv;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float getStar(float size, vec2 offset) {
    return size / distance(vUv, vec2(0.5) + offset) * max(0.5, sin(uTime * size * 100.0));
}


void main() {

    float strength = .05;
    vec3  color = vec3(0.0);


    // Checkboard pattern
    if (uPattern == 0.0) {
        vec2 gridUv = vec2(
            floor(vUv.x * 10.0) / 10.0,
            floor(vUv.y * 10.0) / 10.0
        );
        color = vec3(random(gridUv));
    }
    
    // Stars
    if (uPattern == 0.1) {
        
        float point01 = getStar(0.008, vec2(0.01, 0.05));
        color += point01;

        float point02 = getStar(0.002, vec2(-0.08, 0.0));
        color += point02;

        float point03 = getStar(0.005, vec2(0.30, 0.25));
        color += point03;

        float point04 = getStar(0.003, vec2(-0.44, 0.32));
        color += point04;    
        
        float point05 = getStar(0.002, vec2(0.20, -0.12));
        color += point05;    
        
        float point06 = getStar(0.004, vec2(-0.41, -0.22));
        color += point06;

        float point07 = getStar(0.004, vec2(-0.11, -0.39));
        color += point07;
    }


    // Noise color
    if (uPattern == 0.2) {
        strength = step(0.9, sin(cnoise(vUv * 4.0) * 20.0));
        strength = clamp(strength, 0.0, 1.0);

        color = vec3(vUv, 1.0) * strength;
    }
    

    gl_FragColor = vec4(color, 1.0);
}
