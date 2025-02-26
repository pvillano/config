#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#ifdef wallpaperapp
uniform float battery;
uniform vec2 offset;
uniform int powerConnected;
uniform vec2 resolution;
uniform float time;
#endif

const float PI= 3.14158365;
const float count = 7.0;
const float density = 30.0;
const float period = 2.0;

#define sin1(t) sin(2.0*PI*t)
#define cos1(t) cos(2.0*PI*t)
#define cart(f) vec2(cos1(f), sin1(f))
#define mod1(t) t-floor(t)
#define tri(t)  abs(2.*mod1(t)-1.)
float f(vec2 xy){
    float mg = 0.0;
    for (float i = 0.0; i < count; ++i){
        vec2 dir = cart(i/count);
        float t = 2.0*sin(i*4.0)*time;
        mg += sin1(dot(xy*density, dir) + t);
    }
    return mg;
}

/* the opacities are overlapping triangle waves
 /\/\/\
 \/\/\/
*/
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #ifdef wallpaperapp
    float iTime = time;
    vec2 resolution = iResolution;
    #else
    vec2 offset = vec2(.0, 0.);
    float battery = .5;
    int powerConnected = 0;

    #endif
    vec2 uv = fragCoord.xy / resolution.yy
    + vec2(.2*offset.x-.5, -.5);
    float t2 = iTime / period;
    float mg = f(uv) * tri(t2)+ f(2.*uv) * tri(t2+.5);

    float bg = clamp(mg*2. - count*.2, 0., 1.);
    float fg = clamp(mg*2. + count*.4, 0., 1.);

    float h = battery - uv.y - .5;//0 to 1
    if (powerConnected==1) {
        h += .005*sin1(uv.x*2.0 + 6.0*iTime);
        h += .010*sin1(uv.x*2.0 + 2.0*iTime);
    }
    float op = smoothstep(-.002, .002, h);
    if (powerConnected==1){
        fg = op * (.9 +.1*sin1(20.0*h+3.0*iTime));
    }
    fragColor = vec4(mix(bg, fg, op));
}

#ifdef wallpaperapp

void main(void) {
    mainImage(gl_fragColor, gl_FragCoord);
}
#endif