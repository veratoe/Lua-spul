vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 c = 0.900 * texture2D(texture, texture_coords);
	c *= step(0.005, c.a);
	return c;
}
