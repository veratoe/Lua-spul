extern vec2 direction;

uniform float weights[5] = float[](
0.2270270270, 
0.1945945946, 
0.1216216216,
0.0540540541, 
0.0162162162
);

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec2 uv = texture_coords;
	vec4 c = weights[0] * texture2D(texture, uv);
	for (int i = 1; i < 5; i++ ){
		c += weights[i] * texture2D(texture, uv + vec2( direction.x * float(i) / 800.0, direction.y * float(i) / 600.0 ));
		c += weights[i] * texture2D(texture, uv - vec2( direction.x * float(i) / 800.0, direction.y * float(i) / 600.0 ));
	}
	return c;
}
