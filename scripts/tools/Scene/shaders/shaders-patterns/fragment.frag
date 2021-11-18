#define PI 3.14159265358979323846264338327950288419716939937510

// precision mediump float;

uniform float uTime;
uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
vec4 permute(vec4 x){return mod(((x*34.)+1.)*x,289.);}

float cnoise(vec2 P){
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 *
        vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

void main() {
    float strength = .1;

    // strength = step(0.8, mod(vUv.y * 10.0, 1.0));
    // strength *= step(0.8, mod(vUv.x * 10.0, 1.0));

    // strength = min(abs(vUv.x - .5), abs(vUv.y-.5));

    // strength = max(abs(vUv.x - .5), abs(vUv.y-.5));

    // strength = step(.48, max(abs(vUv.x - .5), abs(vUv.y-.5)));

    // Checkboard
    // strength = floor(vUv.x * 10.0) / 10.0;
    // strength *= floor(vUv.y * 10.0) / 10.0;

    // Noise
    // strength = random(vUv);

    // Checkboard noise
    // vec2 gridUv = vec2(
    //     floor(vUv.x * 10.0) / 10.0,
    //     floor(vUv.y * 10.0) / 10.0
    // );
    // strength = random(gridUv);

    // Skewed checkboard noise
    // vec2 gridUv = vec2(
    //     floor(vUv.x * 10.0) / 10.0,
    //     floor((vUv.y + vUv.x * .3) * 10.0) / 10.0
    // );
    // strength = random(gridUv);

    // Circle
    // strength = distance(vUv, vec2(0.5));

    // Star like effect
    // strength = 0.015 / distance(vUv, vec2(0.5));

    // Stretched galaxy like effect
    // vec2 lightUv = vec2(
    //     vUv.x * .1 + .45,
    //     vUv.y * .5 + .25
    // );
    // strength = 0.015 / distance(lightUv, vec2(0.5));

    // Black circle on white bg
    // strength = step(.2, distance(vUv, vec2(0.5)));

    // strength = abs(distance(vUv, vec2(0.5)) - .25);

    // Circle border
    // strength = step(.01, abs(distance(vUv, vec2(0.5)) - .25));

    // vec2 wavedUv = vec2(
    //     vUv.x,
    //     vUv.y + sin(vUv.x * 30.0) * .1
    // );
    // strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - .25));

    // vec2 wavedUv = vec2(
    //     vUv.x + sin(vUv.y * 30.0) * .1,
    //     vUv.y + sin(vUv.x * 30.0) * .1
    // );
    // strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - .25));

    // vec2 wavedUv = vec2(
    //         vUv.x + sin(vUv.y * 100.0) * .1,
    //         vUv.y + sin(vUv.x * 100.0) * .1
    // );
    // strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - .25));


    // Angle
    // float angle = atan(vUv.x, vUv.y);
    // strength = angle;

    // float angle = atan(vUv.x - .5, vUv.y - .5);
    // angle /= PI * 2.0;
    // angle += .5;
    // angle *= 5.0;
    // angle = mod(angle, 1.0);
    // strength = angle;

    // float angle = atan(vUv.x - .5, vUv.y - .5);
    // angle /= PI * 2.0;
    // angle += .5;
    // strength = sin(angle * 50.0);

    // Wave circle border
    // float angle = atan(vUv.x - .5, vUv.y - .5);
    // angle /= PI * 2.0;
    // angle += .5;
    // float sinusoid = sin(angle * 100.0);

    // float radius = 0.25 + sinusoid * 0.02;
    // strength = 1.0 - step(0.005, abs(distance(vUv, vec2(0.5)) - radius));

    // Noise
    // strength = cnoise(vUv * 10.0);

    // Noise 2
    // strength = step(0.0, cnoise(vUv * 10.0));

    // Noise 3
    // strength = 1.0 - abs(cnoise(vUv * 10.0));

    // Noise 4
    strength = step(0.9, sin(cnoise(vUv * 4.0) * 20.0));
    strength = clamp(strength, 0.0, 1.0);
    vec3 color = vec3(vUv.x, vUv.y, 1.0) * strength;


    // gl_FragColor = vec4(vec3(strength), 1.0);
    gl_FragColor = vec4(color, 1.0);
}
