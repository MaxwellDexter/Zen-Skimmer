shader_type canvas_item;

uniform float outer_r = 0.0;
uniform float inner_r = 0.0;
uniform vec3 colour = vec3(1.0, 1.0, 1.0);

void fragment()
{
	vec2 uv = UV;
	uv -= 0.5;
	float d = length(uv);
	vec4 c;
	
	if (d < outer_r && d > inner_r)
		c = vec4(colour, 1.0);
	else
		c = vec4(1.0, 1.0, 1.0, 0.0);
	
	COLOR = vec4(c);
}