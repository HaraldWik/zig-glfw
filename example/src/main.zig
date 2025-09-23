const std = @import("std");
const builtin = @import("builtin");
const glfw = @import("glfw");

pub fn main() !void {
    try glfw.init();
    defer glfw.deinit();

    glfw.Window.Hint.set(.{ .client_api = .opengl });
    glfw.Window.Hint.set(.{ .context_version_major = 4 });
    glfw.Window.Hint.set(.{ .context_version_minor = 6 });
    glfw.Window.Hint.set(.{ .resizable = false });

    const window: *glfw.Window = try .init(.{
        .title = "Hello, world!",
        .size = .{ .width = 900, .height = 800 },
    });
    defer window.deinit();

    try glfw.Window.Attribute.set(.resizable, window, true);

    std.debug.print("GLFW: {s}\n", .{glfw.version.getStr()});

    glfw.opengl.makeContextCurrent(window);
    defer glfw.opengl.makeContextCurrent(null);

    std.debug.print("\nVulkan is {s}supported\n", .{if (try glfw.vulkan.supported()) "" else "not "});

    const exts = glfw.vulkan.getRequiredInstanceExtensions();
    for (exts) |ext| {
        std.debug.print("\t{s}\n", .{ext});
    }

    std.debug.print("\nBuild Option\n", .{});
    inline for (@typeInfo(glfw.build_options).@"struct".decls) |decl| {
        std.debug.print("\t{s} = {}\n", .{ decl.name, @field(glfw.build_options, decl.name) });
    }

    while (!window.shouldClose()) {
        glfw.io.events.poll();
        glfw.c.glClear(glfw.c.GL_COLOR_BUFFER_BIT);
        glfw.c.glClearColor(0.1, 0.5, 0.3, 1.0);

        if (glfw.io.Key.a.get(window)) {
            glfw.c.glClearColor(1.0, 0.5, 0.3, 1.0);
        }

        if (glfw.io.Key.w.get(window)) {
            glfw.c.glClearColor(1.0, 0.5, 1.0, 1.0);
        }

        try glfw.opengl.swapBuffers(window);
    }
}
