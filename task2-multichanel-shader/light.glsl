#iChannel1 "file://texture1/main.glsl"

vec3 triplanarWeights (in vec3 n) {
    vec3 w = abs(n);
    w *= w;

    return w / (w.x + w.y + w.z);
}

vec4 calclight (
    in vec3 materialpoint, 
    in vec3 norm,
    in vec3 light,
    in vec3 view
) {
    vec3 l = normalize(light - materialpoint);
    vec3 v = normalize(view - materialpoint);
    vec3 vl = 0.5 * (l + v);

    float nl = max(0.0, dot(norm, l));
    float bl = pow(max(0.0, dot(vl, norm)), 20.0);

    vec4 cx = texture(iChannel1, materialpoint.yz);
    vec4 cy = texture(iChannel1, materialpoint.zx);
    vec4 cz = texture(iChannel1, materialpoint.xy);

    vec3 tw = triplanarWeights(norm);

    return (0.8 * nl + 0.4 * bl) * (tw.x * cx + tw.y + cy + tw.z * cz);
}
