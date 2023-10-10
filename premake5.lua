workspace "RayTracer"
    configurations { "Debug", "Release" }

project "RayTracer"
    -- Project config
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"

    -- Output
    targetdir   "%{wks.location}/bin/"
    targetname  "RayTracer.out"
    objdir      "%{wks.location}/bin-int/"

    -- Input
    files 
    {
        "src/**.h",
        "src/**.cpp"
    }

    includedirs
    {
        "src/"
    }

    links
    {
        "glfw",
        "GL",
        "raylib",
    }

    -- Platform specific
    filter "system:linux"
        libdirs { "/usr/lib/", "%{wks.location}/lib/" }
        links { "m", "dl", "pthread" }
        defines { "PLATFORM_LINUX" }

    filter "system:windows"
        libdirs { "%{wks.location}/lib/" }

    -- Configs
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"