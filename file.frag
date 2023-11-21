//#version 330
precision mediump float;

layout(binding=0)uniform FragmentUniforms{
    vec2 size;
    vec2 mouse;
} frag_uniforms;

layout(location=0) out vec4 color;
//layout(location=0) in vec2 screen_pos;

float mandelbrot(vec2 point) {
    int iterations = 256;
    vec2 current = vec2(0, 0);
    for(int i=0;i < iterations;i++){
        current=vec2((current.x*current.x)-(current.y*current.y)+(point.x*4.-2),(current.x*current.y)+(current.y*current.x)+((point.y)*4.-2));
        if((current.x*current.x)+(current.y*current.y)>4){
            return float(i) / float(iterations);
        }
    }
    return 0.0;
}

float julia(vec2 point, vec2 mouse) {
    int iterations = 256;
    vec2 current = point;
    for(int i = 0;i < iterations;i++) {
        current = vec2((current.x*current.x)-(current.y*current.y)+(mouse.x*4.-2),(current.x*current.y)+(current.y*current.x)+((mouse.y)*4.-2));
        if((current.x*current.x)+(current.y*current.y)>4){
            return float(i)/float(iterations);
        }
    }
    return 1.0;
}

void main() {
    //vec2 pos = vec2(4 * screen_pos.x / frag_uniforms.size.x - 2, 4 * screen_pos.y / frag_uniforms.size.y - 2);
    //vec2 mouse = vec2(4 * frag_uniforms.mouse.x / frag_uniforms.size.x - 2, 4 * frag_uniforms.mouse.y / frag_uniforms.size.y - 2);
    //float a = frag_uniforms.size.x;
    color=vec4(0.5,0,0,1);
}