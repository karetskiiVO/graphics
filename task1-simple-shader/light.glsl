vec4 calclight(
    in vec3 materialpoint, 
    in vec3 norm,
    in vec3 light,
    in vec3 view,
    in vec4 color,
    in vec4 backcolor
) {
    vec3 l = normalize(light - materialpoint);
    float nl = max(0.0, dot(norm, l));
    return color * nl;
}