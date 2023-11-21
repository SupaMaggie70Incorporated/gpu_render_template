precision mediump float;

in uint vertex_index;
out vec4 position;


void vs_main() {
    vec2 vertices[6]=vec2[](
        vec2(-1.,-1.),
        vec2(1.,-1.),
        vec2(-1.,1.),
        vec2(1.,-1.),
        vec2(1.,1.),
        vec2(-1.,1.)
    );
    
    position = vec4(vertices[vertex_index], 0.0, 1.0);
}
void main() {
    vec2 vertices[6]=vec2[](
        vec2(-1.,-1.),
        vec2(1.,-1.),
        vec2(-1.,1.),
        vec2(1.,-1.),
        vec2(1.,1.),
        vec2(-1.,1.)
    );

    position=vec4(vertices[vertex_index],0.,1.);
}