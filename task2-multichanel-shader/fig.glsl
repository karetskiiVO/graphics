const float eps = 0.01;

float disttosegment(in vec3 begin, in vec3 end, in vec3 p) {
    vec3 seg = end - begin;
    vec3 beginp = p - begin;
    vec3 endp = p - end;
    
    float t = dot(beginp, seg) / dot(seg, seg);
    
    if (t < 0.0) {
        return length(beginp);
    } else if (t > 1.0) {
        return length(endp);
    }
    
    vec3 projection = begin + t * seg;
    return length(p - projection);
}

float lengthlp(in vec3 v, float p) {
    return pow(
        pow(abs(v.x), p) + pow(abs(v.y), p) + pow(abs(v.z), p),
        1.0 / p
    );
}

const float twoPi = 2.0 * 3.14159265;
float noise(in vec3 p, in mat3 transform) {
    vec3 newp = transform * p.xyx;
    return 0.03 * pow(
        sin(
            20.0 * lengthlp(newp, 12.0) + 
            iTime * twoPi / 6.0
        ),
        4.0
    );
}

float fig(in vec3 p, float r, in mat3 transform) {
    const int samples = 300;
    const float inf = 100.0;

    const float step = twoPi / float(samples);

    float mindist = inf;
    float t = 0.0;
    vec3 prevp = transform * vec3(
        sin(-2.0 * step), 
        cos(-3.0 * step),
        sin(-1.0 * step)
    );

    for (int smpl = 0; smpl < samples; smpl++) {
        vec3 curvep = transform * vec3(
            sin(2.0 * t), 
            cos(3.0 * t),
            sin(1.0 * t)
        );

        // vec3 seg = curvep - p;
        // mindist = min(
        //     mindist, 
        //     length(seg) - r
        // );

        mindist = min(
            mindist, 
            disttosegment(curvep, prevp, p) - r
        );

        prevp = curvep;
        t += step;
    }

    return mindist + noise(p, transform);
}

float sdf(in vec3 p, in mat3 transform) {
    return fig(p, 0.2, transform);
}

vec3 normal(vec3 z, float d, in mat3 transform) {
    float e   = max(d * 0.5, eps);
    float dx1 = sdf(z + vec3(e, 0, 0), transform);
    float dx2 = sdf(z - vec3(e, 0, 0), transform);
    float dy1 = sdf(z + vec3(0, e, 0), transform);
    float dy2 = sdf(z - vec3(0, e, 0), transform);
    float dz1 = sdf(z + vec3(0, 0, e), transform);
    float dz2 = sdf(z - vec3(0, 0, e), transform);
    
    return normalize(vec3 (dx1 - dx2, dy1 - dy2, dz1 - dz2));
}