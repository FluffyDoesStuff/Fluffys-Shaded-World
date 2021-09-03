#version 460 compatibility

in vec2 textureCoordinates;
in vec2 lightmapCoordinates;
in vec4 glColor;
in vec3 N;
in vec3 Entity;
varying vec4 Color;
varying vec2 TexCoords;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform float wetness;
uniform float rainStrength;

uniform sampler2D texture;
uniform sampler2D lightmap;

/* DRAWBUFFERS:025 */
void main() {
  vec4 Albedo = texture2D(texture, TexCoords) * Color;
  if(abs(Entity.x - 20) < 0.001){
    gl_FragData[0] = vec4(Albedo);
    gl_FragData[1] = vec4((N + 1.0) / 2.0, 1.0);
    gl_FragData[2] = vec4(1.0);
  }else{
    gl_FragData[0] = vec4(Albedo);
    gl_FragData[1] = vec4((N + 1.0) / 2.0, 1.0);
    gl_FragData[1] = vec4(1.0);
  }
  //gl_FragData[0] = vec4(Albedo);
}