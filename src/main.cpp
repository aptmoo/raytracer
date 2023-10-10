#include <raylib.h>
#include <raymath.h>
#include <rcamera.h>
#include <rlgl.h>

void DrawScreenQuad();

int main(int argc, char const *argv[])
{
    InitWindow(1280, 720, "Raytracer");

    Shader RayTracingShader = LoadShader("data/vertex.glsl", "data/raytracing.glsl");

    int ViewParamsLoc = GetShaderLocation(RayTracingShader, "ViewParams");
    int TargetLoc = GetShaderLocation(RayTracingShader, "Target");

    Camera3D camera;
    camera.position = Vector3Zero();
    camera.up = {0.0f, 1.0f, 0.0f};
    camera.target = {1.0f, 0.0f, 0.0f};

    DisableCursor();


    while(!WindowShouldClose())
    {
        float delta = GetFrameTime();
        UpdateCameraPro(&camera,
            (Vector3){
                (IsKeyDown(KEY_W) || IsKeyDown(KEY_UP))*delta -      // Move forward-backward
                (IsKeyDown(KEY_S) || IsKeyDown(KEY_DOWN))*delta,    
                (IsKeyDown(KEY_D) || IsKeyDown(KEY_RIGHT))*delta -   // Move right-left
                (IsKeyDown(KEY_A) || IsKeyDown(KEY_LEFT))*delta,
                0.0f                                                // Move up-down
            },
            (Vector3){
                GetMouseDelta().x*0.05f,                            // Rotation: yaw
                GetMouseDelta().y*0.05f,                            // Rotation: pitch
                0.0f                                                // Rotation: roll
            },
            0.0f);                              // Move to target (zoom)

        BeginDrawing();
        // Purple should not be visible!
            ClearBackground(PURPLE);

            SetShaderValue(RayTracingShader, ViewParamsLoc, &camera.position, SHADER_UNIFORM_VEC3);
            SetShaderValue(RayTracingShader, TargetLoc, &camera.target, SHADER_UNIFORM_VEC3);
            
            BeginShaderMode(RayTracingShader);
                DrawScreenQuad();
            EndShaderMode();

            DrawText(TextFormat("Cam pos %f, %f, %f", camera.position.x, camera.position.y, camera.position.z), 10, 10, 20, WHITE);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}

void DrawScreenQuad()
{
    Vector2 ScreenSize = {GetScreenWidth(), GetScreenHeight()};
    Vector2 TopLeft = {0, 0};
    Vector2 TopRight = {ScreenSize.x, 0};
    Vector2 BottomLeft = {0, ScreenSize.y};
    Vector2 BottomRight = {ScreenSize.x, ScreenSize.y};

    rlColor3f(1, 1, 1);

    rlBegin(RL_TRIANGLES);
    rlTexCoord2f(0, 1);
    rlVertex2f(TopLeft.x, TopLeft.y);
    rlTexCoord2f(0, 0);
    rlVertex2f(BottomLeft.x, BottomLeft.y);
    rlTexCoord2f(1, 1);
    rlVertex2f(TopRight.x, TopRight.y);

    rlTexCoord2f(1, 1);
    rlVertex2f(TopRight.x, TopRight.y);
    rlTexCoord2f(0, 0);
    rlVertex2f(BottomLeft.x, BottomLeft.y);
    rlTexCoord2f(1, 0);
    rlVertex2f(BottomRight.x, BottomRight.y);
    rlEnd();
}
