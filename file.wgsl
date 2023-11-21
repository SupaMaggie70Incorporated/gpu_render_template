struct FragmentUniforms {
    size: vec2<f32>,
    mouse: vec2<f32>
};


@group(0) @binding(0) var<uniform> frag_uniforms : FragmentUniforms;

// Fragment shader

fn mandelbrot(point: vec2<f32>) -> f32 {
    var iterations: i32 = 256;
    var current: vec2<f32> = vec2<f32>(0.0, 0.0);
    for(var i: i32 = 0;i < iterations;i++) {
        current = vec2<f32>((current.x * current.x) - (current.y * current.y) + point.x, (current.x * current.y) + (current.y * current.x) + point.y);
        if ((current.x * current.x) + (current.y * current.y) > 4.0) {
            return f32(i) / f32(iterations);
        }
    }
    return 0.0;
}

fn julia(point: vec2<f32>) -> f32 {
    var iterations: i32 = 256;
    var current: vec2<f32> = point;
    for(var i: i32 = 0;i < iterations;i++) {
        current = vec2<f32>((current.x * current.x) - (current.y * current.y) + ((frag_uniforms.mouse.x / frag_uniforms.size.x) * 4.0 - 2.0), (current.x * current.y) + (current.y * current.x) + ((frag_uniforms.mouse.y / frag_uniforms.size.y) * 4.0 - 2.0));
        if ((current.x * current.x) + (current.y * current.y) > 4.0) {
            return f32(i) / f32(iterations);
        }
    }
    return 1.0;
}

@fragment
fn main(@builtin(position) position: vec4<f32>) -> @location(0) vec4<f32> {
    var point = vec2<f32>(position.x / frag_uniforms.size.x * 4.0 - 2.0, position.y / frag_uniforms.size.y * 4.0 - 2.0);
    return vec4<f32>(0.0, mandelbrot(point) / 8.0, julia(point), 1.0);
}