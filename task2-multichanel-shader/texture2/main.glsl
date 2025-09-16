float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + 
           (c - a) * u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

void mainCubemap(out vec4 fragColor, in vec2 fragCoord, in vec3 rayOri, in vec3 rayDir) { 
    vec2 uv = fragCoord * 0.01 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    
    float time = iTime * 0.8;
    
    float n1 = noise(uv * 3.0 + time * 0.3);
    float n2 = noise(uv * 5.0 - time * 0.5);
    float n3 = noise(uv * 8.0 + time * 0.7);
    
    float pattern = sin((n1 + n2 * 0.5 + n3 * 0.25) * 10.0 + time);
    
    vec3 color;
    color.r = sin(pattern * 6.283 + time) * 0.5 + 0.5;
    color.g = cos(pattern * 4.0 + time * 1.2) * 0.5 + 0.5;
    color.b = sin(pattern * 3.0 - time * 0.8) * 0.5 + 0.5;
    
    float glow = pow(pattern * 0.5 + 0.5, 2.0);
    color += vec3(glow * 0.3) * vec3(1.0, 0.5, 0.2);
    color = mix(color, color * color, 0.7);
    
    fragColor = vec4(color, 1.0);
}