precision mediump float;

uniform float kzTime;
uniform vec2 Resolution;
uniform sampler2D Texture;
varying vec2 fragCoord;

#define iTime kzTime

vec2 bend( in vec2 p, in float l, in float a )
{
    if( abs(a)<0.001 ) return p;  // if perfectly straight
    
    float ra = 0.5*l/a;
    p.x -= ra;
    
    vec2 sc = vec2(sin(a),cos(a));
    vec2 q = p - 2.0*sc*max(0.0,dot(sc,p));
    
    float s = sign(a);
    return vec2( (p.y>0.0) ? ra-s*length(q)        : sign(-s*p.x)*(q.x+ra),
                 (p.y>0.0) ? ra*atan(s*p.y,-s*p.x) : (s*p.x<0.0)?p.y:l-p.y );
}

float checker( in vec2 p )
{
    vec2 w = vec2(0.02);//fwidth(p) + 0.01;  
    vec2 i = 2.0*(abs(fract((p-0.5*w)/2.0)-0.5)-abs(fract((p+0.5*w)/2.0)-0.5))/w;
    return 0.5 - 0.5*i.x*i.y;                  
}

float sdArc( in vec2 p, in vec2 scb, in float ra, in float rb )
{
    p.x = abs(p.x);
    float k = (scb.y*p.x>scb.x*p.y) ? dot(p.xy,scb) : length(p.xy);
    return sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
}

float sdStar(in vec2 p, in float r, in int n, in float m) // m=[2,n]
{
    // these 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en)); // ecs=vec2(0,1) and simplify, for regular polygon,
    // reduce to first sector
    float bn = mod(atan(p.x,p.y),2.0*an) - an;
    p = length(p)*vec2(cos(bn),abs(sin(bn)));
    // line sdf
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}

void main()
{
    // normalized pixel coordinates
    vec2 q = (fragCoord*2.0-1.0)*Resolution/Resolution.y;
   
    // recenter
    vec2 p = q; p.y += 0.4;
    // space bend
    float an = 0.6*sin(iTime*3.0);
    an *= 1.0 - smoothstep(1.0,2.0,abs(p.x));
    p = bend(p,2.0,an);

    // star
    float d = sdStar(p-vec2(0.0,0.4), 0.8, 5, 3.0 ) - 0.05;
    d = max( d, -sdArc( vec2(abs(p.x)-0.2,p.y-0.44), vec2(0.8,0.6), 0.15, 0.02 ) );
    d = max( d, -sdArc( vec2(p.x,0.45-p.y), vec2(0.8,0.6), 0.25, 0.05 ) );
        
    // coloring
    vec3 col = texture2D(Texture,q+0.5).xyz;
    if( sin(iTime)<0.0 )
    {
        col = vec3(0.6+0.1*checker(p*6.0));
        //col *= 1.0 + 0.1*cos(128.0*d);
    }
    col *= 1.0 - 0.75*exp(-10.0*d);
    if( d<0.0 )
        col = texture2D(Texture,p+0.5).xyz;
    col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.01,abs(d)) );
    col = sqrt(col);

    gl_FragColor = vec4(col, 1.0);
}
