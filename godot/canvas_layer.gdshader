shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float amplitude : hint_range(0.0, 0.3) = 0.005;
uniform float frequency : hint_range(0.0, 20.0) = 10.0;

uniform float blur_width : hint_range(0.0, 0.3) = 0.1; // 境界のぼかし幅

uniform vec4 water_color : source_color = vec4(0.4, 0.2, 0.3, 1.0);
uniform vec4 bg_color : source_color = vec4(0.1, 0.1, 0.15, 1.0);

void fragment() {
    vec2 uv = UV;

    // 波の高さ
    float wave = sin(uv.x * frequency + TIME * speed) * amplitude;
	wave += cos(uv.x * frequency + TIME * speed * 2.0) * amplitude * 0.1;
	wave += sin(uv.x * frequency + TIME * speed * 4.0) * amplitude * 0.05;

    // 境界位置
    float border = 0.05 + wave;

    // smoothstep で境界をぼかす
    float mix_value = smoothstep(border - blur_width, border + blur_width, uv.y);

    // mix_value が 0 → 水色、1 → 背景色
    COLOR = mix(water_color, bg_color, mix_value);
}
