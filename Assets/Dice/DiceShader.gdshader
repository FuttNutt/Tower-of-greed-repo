shader_type canvas_item;

uniform vec2 full_texture_pixel_size = vec2(16.0, 96.0);
uniform vec2 crop_offset_pixels = vec2(0.0, 0.0);
uniform vec2 crop_size_pixels = vec2(16.0, 16.0);

uniform vec2 scroll_speed = vec2(0.0, 4.0);

void fragment() {
    // 1. Map local UV (0.0 to 1.0) to actual pixel position inside the crop box
    vec2 current_crop_pixel = UV * crop_size_pixels;
    
    vec2 scrolled_pixel = current_crop_pixel + (scroll_speed * TIME * crop_size_pixels);
    
    vec2 wrapped_pixel = mod(crop_offset_pixels + scrolled_pixel, full_texture_pixel_size);
    
    vec2 final_uv = wrapped_pixel / full_texture_pixel_size;
    
    COLOR = texture(TEXTURE, final_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
