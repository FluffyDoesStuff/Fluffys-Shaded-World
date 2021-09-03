#version 460 compatibility

in vec2 textureCoordinates;

uniform sampler2D gcolor;
uniform sampler2D depthtex0;
uniform sampler2D gnormal;
uniform sampler2D colortex5;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform float wetness;
uniform float rainStrength;

uniform int isEyeInWater;

vec3 localToScreen(vec3 pos) {
  vec3 data = mat3(gbufferProjection) * pos;
  data += gbufferProjection[3].xyz;
  return ((data.xyz / -pos.z) / 2.0 + 0.5).xyz;
}

vec3 screenToLocal(vec3 posDepth) {
  vec4 result = vec4(posDepth, 1.0) * 2.0 - 1.0;
  result      = (gbufferProjectionInverse * result);
  result /= result.w;
  return result.xyz;
}

vec3 raytraceScreen(vec3 screenPosition, vec3 localNormal) {
  vec3 startPosition  = screenToLocal(screenPosition);
  vec3 startDirection = normalize(reflect(normalize(startPosition), localNormal));
  vec3 endPosition    = startPosition + (startDirection * 200.0);
  vec3 result         = vec3(0.0);

  float minStep  = 0.01;  // clamp(0.00001, 0.001, distance(vec3(0.0), startPosition) / 100000.0)
  float stepSize = 0.001;
  for (float currentStep = 0.01; currentStep <= 1.0; currentStep += stepSize) {
    vec3 currentPosition = mix(startPosition, endPosition, pow(currentStep, 1.0));
    vec3 screenQuery     = localToScreen(currentPosition);
    vec3 localQuery      = screenToLocal(vec3(screenQuery.xy, texture2D(depthtex0, screenQuery.xy)));

    if ((currentPosition.z - localQuery.z) <= 0.0) {
      result = currentPosition;
      break;
    }
  }

  vec3 refinementDirection = startDirection / 1.0;
  for (int refinementStep = 0; refinementStep < 100; ++refinementStep) {
    vec3 screenQuery = localToScreen(result);
    vec3 localQuery  = screenToLocal(vec3(screenQuery.xy, texture2D(depthtex0, screenQuery.xy)));
    if (screenQuery.x < 0.0 || screenQuery.y < 0.0 || screenQuery.x > 1.0 || screenQuery.y > 1.0)
    break;

    result += refinementDirection * (((result.z - localQuery.z) <= 0.0) ? -1.0 : 1.0);
    refinementDirection /= 2.0;
    float rainCoefficient = max(rainStrength, wetness);
    vec3 skyclr = mix(skyColor, fogColor * 0.65, rainCoefficient);
    if (screenQuery.xy != clamp(screenQuery.xy, vec2(0.0), vec2(1.0))){;
      return vec3(0);
    }else if(abs(isEyeInWater) > 0.001){
        return vec3(0);
    } else{
      return vec3(localToScreen(result).xy, (length(result) > 0.0) ? 1.0 : 0.0);
    }
  }
}
int getBlockId(sampler2D tex, vec2 coords) {
  return int(texture2D(tex, coords).r * 255.0 + 0.5);
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 pixel;

void main() {
    float blockID = texture2D(colortex5, textureCoordinates).r;
    vec3  color       = texture2D(gcolor, textureCoordinates).rgb;
    vec3  worldNormal = texture2D(gnormal, textureCoordinates).xyz * 2.0 - 1.0;
    float depth       = texture2D(depthtex0, textureCoordinates).g;
    if (blockID > 0.001) { // your mask is greater than 0.001 so > is correct not <
        vec3 rt = raytraceScreen(vec3(textureCoordinates, depth), normalize(mat3(gbufferModelView) * worldNormal));
        color   = mix(color, texture2D(gcolor, rt.xy).rgb, rt.z * 0.5);
    }
    pixel = vec4(color, 1.0);
    // pixel = vec4(mat3(gbufferModelView) * worldNormal, 1.0);
}