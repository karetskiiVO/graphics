#include "fig.glsl"

const int maxSteps = 65;
const float maxDist = 10.0;

bool raycast(in vec3 from, in vec3 dir, in mat3 transform, out vec3 hit) {
    vec3 p = from;
    float totalDist = 0.0;

    for (int step = 0; step < maxSteps; step++) {
        float dist = sdf(p, transform);

        if (dist < eps) {
            hit = p;
            return true;
        }

        totalDist += dist;
        if (totalDist > maxDist) break;

        p += dist * dir;
    }

    hit = p;
    return false;
}
