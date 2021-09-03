#version 120
varying vec2 TexCoords;
uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex5;
uniform sampler2D colortex7;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D depthtex1;
uniform sampler2D depthtex0;
uniform sampler2D shadowcolor0;
#define viewOutput colortex0 //[colortex0  colortex5 colortex7 colortex2 shadowcolor0 depthtex1 colortex9 colortex10]
#define saturation 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

vec3 adjustSaturation(vec3 color, float value) {
  const vec3 luminosityFactor = vec3(0.2126, 0.7152, 0.0722);
  vec3 grayscale = vec3(dot(color, luminosityFactor));

  return mix(grayscale, color, 1.0 + value);
}

void main() {
    // Sample and apply gamma correction
    vec3 color = pow(texture2D(viewOutput, TexCoords).rgb, vec3(1.0 / 2.2));
    color = adjustSaturation(color, saturation);
    gl_FragColor = vec4(color, 1.0);
}