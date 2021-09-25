#version 120

varying vec2 texcoord;
attribute vec3 mc_Entity;
varying vec3 Entity;

void main()
{
	Entity = mc_Entity.xyz;
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}