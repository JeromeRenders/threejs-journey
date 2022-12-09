
uniform vec3 uColor;

void main() {

    float dist = distance(gl_PointCoord, vec2(0.5));
    float strength = 0.05 / dist - 0.05 * 2.0;

    gl_FragColor = vec4(uColor, strength);
}
