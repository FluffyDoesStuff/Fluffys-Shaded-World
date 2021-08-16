#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 TexCoords;
varying vec4 glcolor;
uniform sampler2D colortex0;
uniform sampler2D colortex7;

void main() {
    /* DRAWBUFFERS:0 */
	gl_FragData[0] = texture2D(colortex0, TexCoords) + texture2D(colortex7, TexCoords);
}