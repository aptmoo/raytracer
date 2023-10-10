#version 330
// Input
in vec2 uv;
// Output fragment color
out vec4 finalColor;

// Uniforms
uniform vec3 ViewParams;
uniform vec3 Target;

struct Ray
{
    vec3 origin;
    vec3 direction;
};

struct HitResult
{
    bool didHit;
    float dist;
    vec3 hitPoint;
    vec3 hitNormal;
};

HitResult RaySphere(in Ray ray, in vec3 center, float radius)
{
    HitResult result;
    result.didHit = false;
    result.dist = 0;
    result.hitPoint = vec3(0);
    result.hitNormal = vec3(0);

    vec3 offsetRayOrigin = ray.origin - center;

    float a = dot(ray.direction, ray.direction);
    float b = 2 * dot(offsetRayOrigin, ray.direction);
    float c = dot(offsetRayOrigin, offsetRayOrigin) - (radius * radius);

    float disc = b*b - 4 * a * c;

    if(disc > 1)
    {
        float dist = (-b - sqrt(disc)) / (2 * a);

        if(dist > 0)
        {
            result.didHit = true;
            result.dist = dist;
            result.hitPoint = ray.origin + ray.direction * dist;
            result.hitNormal = normalize(result.hitPoint - center);
        }
    }

    return result;
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

void main()
{
    vec2 viewPointLocal = vec2(uv - vec2(0.5))*2;
    mat3 cameraLocalToWorld = setCamera(ViewParams, Target, 0);

    

    Ray ray;
    ray.origin = ViewParams;
    ray.direction = cameraLocalToWorld * normalize(vec3(viewPointLocal.xy, 2.0));

    finalColor = RaySphere(ray, vec3(0, 0, 0), 1).didHit ? vec4(1) : vec4(0, 0, 0, 1);
}