shader_type spatial;
render_mode unshaded, cull_front, depth_draw_always;
uniform float outline_width : hint_range(0.0, 1.0) = 0.02;

void vertex() {
    vec3 push_direction = sign(VERTEX);
    VERTEX += push_direction * outline_width;
}

void fragment() {
    ALBEDO = vec3(0.0, 0.81, 0.94);
}
