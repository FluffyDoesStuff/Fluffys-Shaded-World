#version 120

#define FOG_COLOR vec3(1.0, 0.0, 0.0)
#define FOG_DENSITY 0.02

varying vec2 texcoord;

uniform mat4 gbufferProjectionInverse;

uniform sampler2D depthtex0;
uniform sampler2D colortex0;

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
	float fog = 1.0-exp(-length(view_position) * FOG_DENSITY);
	
	//Blend fog color with the scene
	scene = mix(scene, FOG_COLOR, fog);

    /*DRAWBUFFERS:0*/
    gl_FragData[0] = vec4(scene, 1.0);
}


