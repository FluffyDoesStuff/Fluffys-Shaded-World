#version 120

varying vec2 TexCoords;
uniform vec3 sunPosition;

void main() {
  TexCoords = gl_MultiTexCoord0.st;
  gl_Position = ftransform();
}
