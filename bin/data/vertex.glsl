#version 330

// Input vertex attributes
in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

out vec2 uv;

// Input uniform values
uniform mat4 mvp;

// Output vertex attributes (to fragment shader)

// NOTE: Add here your custom variables

void main()
{
    // Send vertex attributes to fragment shader
    uv = vertexTexCoord;

    // Calculate final vertex position
    gl_Position = mvp*vec4(vertexPosition, 1.0);
}