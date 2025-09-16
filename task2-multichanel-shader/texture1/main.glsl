float random(vec2 st, float seed) {
    return fract(
        sin(dot(st.xy, vec2(12.9898, 78.233))) * 
        seed * 127.37
    );
}

const float cellSize = 100.0;

void mainImage (out vec4 fragColor, in vec2 fragCoord) {
    vec2 cell = ceil(fragCoord / cellSize);

    fragColor =  vec4(
        pow(random(cell, 101.2 + 0.0147  * iTime), 4.0), 
        pow(random(cell, 157.0 + 0.00034 * iTime), 4.0), 
        pow(random(cell, 342.1 + 0.0057  * iTime), 4.0), 
        pow(random(cell, 12.0  + 0.0012  * iTime), 4.0)
    );    
}