// Generalized mandelbrot to any dimension using euler's formula, autoadjusts viewport so that the scale is always the same
// Similar to the multibrot set, which generalizes the mandelbrot set to higher, but only integer, dimensions
// The mandelbrot set technically only includes points on the boundary, but this shades points by how quickly they diverge.
// Points which don't diverge are put at black, the same color as the fastest points which do converge to add contrast, if it wasn't this way it would be awful to look at, picture a giant ugly bright green blob
// The very visible contour-esque lines are an artifact of computer screens' weird color systems.
// For the sake of seeing in the near-dark, humans are better at differentiating very dark colors. 
// As a result, images and the like are often stored in sRGB, a color space which focuses more on the darker colors than the lighter colors.
// This means that darker colors are given a disproportionate range of brightness values, while brighter colors are given disproportionately few.
// For the sake of not having to transform images back to unscaled color manually, graphics libraries typically transform the output drawn to the screen themself.
// This involves squeezing the dark parts into less values and stretching the light parts out into more.
// Since this isn't done in sRGB, but is being treated like it is, the darkest colors are being squeezed very few colors, which results in very sharp contour-lines
// I didn't handle this because it works differently on every platform, e.g. web vs desktop which uses DirectX or Vulkan. sRGB is the recommended way to do rendering, and I didn't wanna mess around with it.

struct FragmentUniforms {
    size: vec2<f32>,
    mouse: vec2<f32>
};


@group(0) @binding(0) var<uniform> frag_uniforms : FragmentUniforms;

fn mandelbrot(point: vec2<f32>) -> f32 {
    var iterations: i32 = 1024;
    var current: vec2<f32> = vec2<f32>(0.0, 0.0);
    for(var i: i32 = 0;i < iterations;i++) {
        current = vec2<f32>((current.x * current.x) - (current.y * current.y) + point.x, (current.x * current.y) + (current.y * current.x) + point.y);
        if ((current.x * current.x) + (current.y * current.y) > 4.0) {
            return f32(i) / f32(iterations);
        }
    }
    return 0.0;
}

fn complex_exp(n: vec2<f32>) -> vec2<f32> {
    var r = exp(n.x);
    var theta = n.y;


    var x = r * cos(theta);
    var y = r * sin(theta);
    return vec2<f32>(x, y);
}

fn complex_mul(a: vec2<f32>, b: vec2<f32>) -> vec2<f32> {
    return vec2<f32>(
        a.x * b.x - a.y * b.y,
        a.x * b.y + a.y * b.x
    );
}

fn complex_log(a: vec2<f32>) -> vec2<f32> {
    var r = sqrt(a.x * a.x + a.y * a.y);
    var theta = atan2(a.y, a.x);
    return vec2<f32>(log(r), theta);
}

fn get_generalized_limit(degree: vec2<f32>) -> f32 {
    return pow(2.0 * degree.x, 1.0 / degree.x);
}

fn complex_pow(input: vec2<f32>, deg: vec2<f32>) -> vec2<f32> {
    return complex_exp(complex_mul(complex_log(input), deg));
}

fn generalized_mandelbrot(point: vec2<f32>, degree: vec2<f32>, outer_limit: f32) -> f32 {
    var iterations: i32 = 1024;
    var current: vec2<f32> = vec2<f32>(0.0, 0.0);
    var limitSquared = outer_limit * outer_limit;
    for(var i: i32 = 0;i < iterations;i++) {
        current = complex_pow(current, degree) + point;
        if ((current.x * current.x) + (current.y * current.y) > limitSquared) {
            return f32(i) / f32(iterations);
        }
    }
    return 0.0;
}

@fragment
fn main(@builtin(position) position: vec4<f32>) -> @location(0) vec4<f32> {
    let min_deg = 1.0;
    let max_deg = 11.0;
    let min_i_deg = -5.0;
    let max_i_deg = 5.0;
    var degree = vec2<f32>(
        (max_deg - min_deg) * (frag_uniforms.mouse.x / frag_uniforms.size.x) + min_deg,
        0.0
    );
    var limit = get_generalized_limit(degree);
    var posx = (position.x / frag_uniforms.size.x - 0.5) * (2.0 * limit);
    var posy = (position.y / frag_uniforms.size.y - 0.5) * (2.0 * limit);
    var point = vec2<f32>(posx, posy);
    var mandel = generalized_mandelbrot(point, degree, limit);
    return vec4<f32>(0.0, mandel * 4.0, 0.0, 1.0);
}