const std = @import("std");
const glfw = @import("glfw");

pub fn main() !void {
    try glfw.init();
    defer glfw.deinit();

    const window: glfw.Window = try .init(.{
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

        if (glfw.io.Key.a.get(window).press) {
            std.debug.print("A\n", .{});
        }

        try glfw.opengl.swapBuffers(window);
    }
}
