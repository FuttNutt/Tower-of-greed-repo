shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.0, 4.0);

void fragment() {
    // Shift UV coordinates over time
    vec2 shifted_uv = fract(UV + (scroll_speed * TIME));
    COLOR = texture(TEXTURE, shifted_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
