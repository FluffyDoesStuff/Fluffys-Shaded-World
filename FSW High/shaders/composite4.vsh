#version 120
varying vec4 Color;
varying vec2 TexCoords;

void main() {
   gl_Position = ftransform();
   TexCoords = gl_MultiTexCoord0.st;
   Color = gl_Color;
}