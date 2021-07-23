#version 120

uniform vec3 sunPosition;
uniform float viewHeight, viewWidth;

vec3 rgb(float r, float g, float b) {
	return vec3(r / 255.0, g / 255.0, b / 255.0);
}

vec4 circle(vec2 uv, vec2 pos, float rad, vec3 color) {
	float d = length(pos - uv) - rad;
	float t = clamp(d, 0.0, 1.0);
	return vec4(color, 1.0 - t);
}

void main(){
    vec2 screen_res = vec2(viewWidth, viewHeight);
    vec2 uv = sunPosition.xy;
	vec2 center = screen_res.xy * 0.5;
	float radius = 0.25 * screen_res.y;
	
	// Circle
	vec3 red = rgb(252.0, 212.0, 64.0);
	vec4 layer2 = circle(uv, center, radius, red);
	
	gl_FragColor = vec4(layer2);
}