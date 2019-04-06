vec3 luminanceVector = vec3(0.2125, 0.7154, 0.0721);
float luminanceThreshold = 0.5;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 c = texture2D(texture, texture_coords);
	float luminance = dot(c.xyz, luminanceVector);
	return c; //step(0.0, luminance) * c;
}
