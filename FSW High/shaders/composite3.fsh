#version 120
uniform float viewHeight, viewWidth;
uniform sampler2D colortex8; //Change if needed
const float[] KERNEL = float[](
    0.0002602369071590887,
    0.00044674386673403804,
    0.0007459616463367329,
    0.001211551050206142,
    0.0019139623838268058,
    0.0029409708367950657,
    0.004395547032751061,
    0.0063899785619232876,
    0.009035446856672853,
    0.012426914866374887,
    0.01662418455722773,
    0.021631210113023065,
    0.027376945377152462,
    0.0337018124963318,
    0.04035394508489358,
    0.046998436581582835,
    0.053240893744425796,
    0.058663934167997873,
    0.06287243082034108,
    0.06554100809015972,
    0.06645576991616818,
    0.06554100809015972,
    0.06287243082034108,
    0.058663934167997873,
    0.053240893744425796,
    0.046998436581582835,
    0.04035394508489358,
    0.0337018124963318,
    0.027376945377152462,
    0.021631210113023065,
    0.01662418455722773,
    0.012426914866374887,
    0.009035446856672853,
    0.0063899785619232876,
    0.004395547032751061,
    0.0029409708367950657,
    0.0019139623838268058,
    0.001211551050206142,
    0.0007459616463367329,
    0.00044674386673403804,
    0.0002602369071590887
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
    vec2 onePixel = 2.0 / size;
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
    vec3 color = texture2D(colortex8, uv).xyz;
    
    //Blur
    color = gaussian(colortex8, vec2(0.0, 1.0), screen_res, uv).xyz;
    
    /*DRAWBUFFERS:09*/
    gl_FragData[1] = vec4(color, 1.0);
}