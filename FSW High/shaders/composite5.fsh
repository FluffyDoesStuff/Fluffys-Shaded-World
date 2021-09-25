#version 130
#define FOG_DENSITY 0.0006 
#define WATER_FOG_DENSITY 0.03

varying vec2 texcoord;

uniform mat4 gbufferProjectionInverse;

uniform sampler2D depthtex0;
uniform sampler2D colortex0;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float wetness;
uniform float rainStrength;
uniform int isEyeInWater;
in vec3 Entity;

void main()
{
    //Sample scene color
    vec3 scene = texture2D(colortex0, texcoord).xyz;

    //Get positions
    vec3 screen_position = vec3(texcoord, texture2D(depthtex0, texcoord).r);
    vec3 clip_position = screen_position * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * vec4(clip_position, 1.0);
    vec3 view_position = tmp.xyz / tmp.w;

    //Fog (exponential)
    //float fog = 1.0-exp(-length(view_position) * FOG_DENSITY);
    float rainCoefficient = max(rainStrength, wetness);
    vec3 skyclr = mix(skyColor, fogColor * 0.65, rainCoefficient);
    if(isEyeInWater == 1){
        float fog = 1.0-exp(-length(view_position) * WATER_FOG_DENSITY);
        scene = mix(scene, skyclr, fog);
        /* RENDERTARGETS:0 */ 
        if(fog < 1){
        gl_FragData[0] = vec4(scene, 1.0);
        } else{
            gl_FragData[0] = vec4(scene, 0.0);
        }
    } else{
        float fog = 1.0-exp(-length(view_position) * FOG_DENSITY);
        scene = mix(scene, skyclr, fog);
        /* RENDERTARGETS:0 */ 
        if(fog < 1){
        gl_FragData[0] = vec4(scene, 1.0);
        } else{
            gl_FragData[0] = vec4(scene, 0.0);
        }
    }
}