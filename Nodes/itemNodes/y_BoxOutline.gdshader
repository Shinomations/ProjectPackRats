shader_type spatial;

render_mode unshaded, cull_front, depth_draw_always;

uniform float outline_width : hint_range(0.0, 10.0) = 0.05;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void vertex() {
    vec3 push_direction = sign(VERTEX);
    
    VERTEX += push_direction * outline_width;
}

void fragment() {
    ALBEDO = outline_color.rgb;
}
