#version 120

uniform float viewHeight, viewWidth;
uniform sampler2D colortex0; //Change if needed
const float[] KERNEL = float[](
  0.0024055085674964125,
  0.009255297393309877,
  0.02786684424768963,
  0.06566651775036977,
  0.12111723251079276,
  0.17486827308986305,
  0.1976406528809569,
  0.17486827308986305,
  0.12111723251079276,
  0.06566651775036977,
  0.02786684424768963,
  0.009255297393309877,
  0.0024055085674964125
);

// vec3 box(sampler2D sampler, vec2 direction, vec2 size, vec2 pos) 
// {
//     vec2 onePixel = 1.0 / size;
//     float weightSum = 0.0;
//     vec3 value = vec3(0.0);
    
//     for (int i = -6; i <= 6; i++) 
//     {
//         float weight = 1.0;
//         value += texture2D(sampler, pos + direction * onePixel * float(i)).xyz * weight;
//         weightSum += weight;
//     }  
//     return value / weightSum;
// }
vec4 gaussian(sampler2D sampler, vec2 direction, vec2 size, vec2 pos) {
    vec2 onePixel = 1.0 / size;
    float weightSum = 0.0;
    vec4 value = vec4(0);
    
    for (int i = -6; i <= 6; i++) {
        float weight = KERNEL[i + 6];
        value += texture2D(sampler, pos + direction * onePixel * float(i)) * weight;
        weightSum += weight;
    }
    
    return value / weightSum;
}

void main()
{
    vec2 screen_res = vec2(viewWidth, viewHeight);
    vec2 uv = gl_FragCoord.xy / screen_res;
    vec3 color = texture2D(colortex0, uv).xyz;
    
    //Blur
    color = gaussian(colortex0, vec2(1.0, 0.0), screen_res, uv).xyz;
    
    /*DRAWBUFFERS:05*/
    gl_FragData[0] = vec4(color,1.0);
}