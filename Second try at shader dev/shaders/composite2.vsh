#version 460 compatibility

out vec2 textureCoordinates;
attribute vec3 mc_Entity;
out vec3 mcEntity;
varying vec4 Color;

void main() {
  gl_Position        = ftransform();
  textureCoordinates = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
