#version 460 compatibility

in vec2 textureCoordinates;
in vec2 lightmapCoordinates;
in vec4 glColor;
in vec3 N;
in vec3 mcEntity;
varying vec4 Color;
varying vec2 TexCoords;


uniform sampler2D texture;
uniform sampler2D lightmap;

/* DRAWBUFFERS:02 */
layout(location = 0) out vec4 normal;
layout(location = 1) out vec4 reflection;
layout(location = 3) out vec4 gcolor;
layout(location = 4) out vec4 gnormal;
void main() {
  gcolor  = glColor * texture2D(texture, textureCoordinates) * texture2D(lightmap, lightmapCoordinates);
  gnormal = vec4((N + 1.0) / 2.0, 1.0);
  vec4 Albedo = texture2D(texture, TexCoords) * Color;
  normal = Albedo;
  if(mcEntity.x == 2000){
    reflection = vec4(1.0);
  }
}