uniform float uProgress;

void main() {

    vec3 color = vec3(0.0);

    gl_FragColor = vec4(color, uProgress);
}
