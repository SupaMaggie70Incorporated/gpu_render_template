struct FragmentUniforms {
    size: vec2<f32>,
    mouse: vec2<f32>
};


@group(0) @binding(0) var<uniform> frag_uniforms : FragmentUniforms;

// Fragment shader

fn mandelbrot(point: vec2<f32>) -> f32 {
    var iterations: i32 = 1024;
    var current: vec2<f32> = vec2<f32>(0.0, 0.0);
    for(var i: i32 = 0;i < iterations;i++) {
        current = vec2<f32>((current.x * current.x) - (current.y * current.y) + point.x, 2.0 * current.x * current.y + point.y);
        if ((current.x * current.x) + (current.y * current.y) > 4.0) {
            return f32(i) / f32(iterations);
        }
    }
    return 0.0;
}

@fragment
fn main(@builtin(position) position: vec4<f32>) -> @location(0) vec4<f32> {
    var point = vec2<f32>(position.x / frag_uniforms.size.x * 4.0 - 2.0, position.y / frag_uniforms.size.y * 4.0 - 2.0);
    return vec4<f32>(0.0, mandelbrot(point), 0.0, 1.0);
}