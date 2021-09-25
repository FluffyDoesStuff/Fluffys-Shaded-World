#version 120

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;
in vec3 Entity;

uniform sampler2D colortex7;

// The texture atlas
uniform sampler2D texture;

float bloomThreshold = 0.7;

void main(){
    // Sample from texture atlas and account for biome color + ambien occlusion
    vec4 Albedo = texture2D(texture, TexCoords) * Color;
    /* DRAWBUFFERS:0128 */
    // Write the values to the color textures

    float brightness = dot(Albedo, vec4(0.2126, 0.7152, 0.0722, 0));
    if(brightness >= bloomThreshold && abs(Entity.x - 30) < 0.001)
    {
        gl_FragData[3] = texture2D(colortex7, TexCoords);
    }
    gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[0] = vec4(Albedo);
}