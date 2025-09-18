# Zig GLFW

btw, handmade...

## Installation

`zig fetch --save git+https://github.com/HaraldWik/zig-glfw`

_build.zig_

```rust
    const zig_glfw = b.dependency("zig_glfw", .{
        .target = target,
        .optimize = optimize,

        // Exposes native api's
        // .win32 = true,
        // .cocoa = true,
        // .x11 = true,
        // .wayland = true,

        .vulkan = true,
        // .none = true, // Gets rid of all the OpenGL api's
        // .wgl = true,
        // .nsgl = true,
        // .glx = true,
        // .egl = true,
        // .osmesa = true,
    }).module("zig_glfw");
```

_main.zig_

```zig
const std = @import("std");
const glfw = @import("glfw");

pub fn main() !void {
    try glfw.init();
    defer glfw.deinit();

    const window: *glfw.Window = try .init(.{
        .title = "Hello, world!",
        .size = .{ .width = 900, .height = 800 },
    });
    defer window.deinit();

    std.log.info("{any}, {s}", .{ glfw.version.get(), glfw.version.getStr() });

    glfw.opengl.makeContextCurrent(window);
    defer glfw.opengl.makeContextCurrent(null);

    std.log.info("Vulkan? {s}", .{if (try glfw.vulkan.supported()) "yes" else "no"});

    const exts = glfw.vulkan.getRequiredInstanceExtensions();
    for (exts) |ext| {
        std.log.info("\t{s}", .{ext});
    }

    while (!window.shouldClose()) {
        glfw.io.events.poll();
        glfw.c.glClearColor(0.1, 0.5, 0.3, 1.0);
        glfw.c.glClear(glfw.c.GL_COLOR_BUFFER_BIT);

        if (glfw.io.Key.a.get(window)) {
            std.debug.print("A\n", .{});
        }

        try glfw.opengl.swapBuffers(window);
    }
}
```

## Features

- Monitor
- Window
- Io (events, keys)
- Vulkan
- Opengl
- All native api's
