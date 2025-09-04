vec4 calclight(
    in vec3 materialpoint, 
    in vec3 norm,
    in vec3 light,
    in vec3 view,
    in vec4 color,
    in vec4 backcolor
) {
    vec3 l = normalize(light - materialpoint);
    vec3 v = normalize(view - materialpoint);
    vec3 vl = 0.5 * (l + v);

    float nl = max(0.0, dot(norm, l));
    float bl = pow(max(0.0, dot(vl, norm)), 20.0);

    return min(
        (color - backcolor) * (nl + bl) + backcolor,
        vec4(1, 1, 1, 1)
    );
}