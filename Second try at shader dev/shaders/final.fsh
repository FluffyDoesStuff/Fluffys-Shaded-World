#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0;

uniform sampler2D shadowcolor0;


void main() {
    // Sample and apply gamma correction
   vec3 shadowView = pow(texture2D(colortex0, TexCoords).rgb, vec3(1.0f / 2.2f));
   vec3 normalView = texture2D(shadowcolor0, TexCoords).rgb;
   gl_FragColor = vec4(shadowView, 1.0f);
}