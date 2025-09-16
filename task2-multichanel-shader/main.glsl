#include "raycast.glsl"
#include "utils.glsl"
#include "light.glsl"

#iChannel2 "file://texture2/main.glsl"

const vec3 eye   = vec3(0, 0, 5);
const vec3 light = vec3(0, 2, 5);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {  
    vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5, iMouse.z - 0.5);
    mat3 transform = 
        rotateX(6.0 * mouse.y) * 
        rotateY(6.0 * mouse.x) *
        rotateZ(iTime);

    vec2 scale = 9.0 * iResolution.xy / max(iResolution.x, iResolution.y);
    vec2 uv  = scale * (fragCoord/iResolution.xy - vec2(0.5));
	vec3 dir = normalize(vec3 (uv, 0) - eye);

    vec3 hit = vec3(0, 0, 0);
    vec4 color = vec4(0, 0, 0, 1);

    if (raycast(eye, dir, transform, hit)) {
        vec3 n = normal(hit, 1e-3, transform);

        color = calclight(
            transform * hit,
            n,
            light,
            eye
        );
    } else {
        //color = texture(iChannel2, dir);
    }

    fragColor = color;
}
