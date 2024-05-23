struct FragmentUniforms {
    size: vec2<f32>,
    mouse: vec2<f32>
};


@group(0) @binding(0) var<uniform> frag_uniforms : FragmentUniforms;

// Fragment shader

fn burning_ship(point: vec2<f32>, zoom: f32) -> f32 {
    var iterations: i32 = 1024;
    var current: vec2<f32> = vec2<f32>(0.0, 0.0);
    for(var i: i32 = 0;i < iterations;i++) {
        current = vec2<f32>((current.x * current.x) - (current.y * current.y) + point.x, abs(2.0 * current.x * current.y) + point.y);
        if ((current.x * current.x) + (current.y * current.y) > 4.0) {
            return f32(i) / f32(iterations);
        }
    }
    return 0.0;
}

@fragment
fn main(@builtin(position) position: vec4<f32>) -> @location(0) vec4<f32> {
    // Let zoom go between 1 and 20
    var zoom = exp((frag_uniforms.mouse.x / frag_uniforms.size.x) * log(8.0));
    // Let center be -1.754, 0.035

    var point = vec2<f32>(position.x / frag_uniforms.size.x * 4.0 - 2.0, position.y / frag_uniforms.size.y * 4.0 - 2.0);
    point = point / zoom;
    point += vec2<f32>(-1.754, -0.035);
    var color = vec3<f32>(1.0, 0.1, 0.0) * burning_ship(point, zoom);
    return vec4<f32>(color, 1.0);
}