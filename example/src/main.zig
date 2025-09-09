const std = @import("std");
const glfw = @import("glfw");

pub fn main() !void {
    try glfw.init.init();
    defer glfw.init.deinit();

    const window: glfw.Window = try .init(.{
        .title = "Hello, world!",
        .size = .{ .width = 900, .height = 800 },
    });
    defer window.deinit();

    std.log.info("{any}, {s}", .{ glfw.init.Version.get(), glfw.init.Version.getStr() });

    try window.initContextCurrent();
    defer window.deinitContextCurrent();
    std.log.info("Vulkan? {s}", .{if (try glfw.vulkan.supported()) "yes" else "no"});
    const exts = glfw.vulkan.getRequiredInstanceExtensions();
    for (exts) |ext| {
        std.log.info("\t{s}", .{ext});
    }

    while (!window.shouldClose()) {
        glfw.io.events.poll();
        glfw.c.glClearColor(0.1, 0.5, 0.3, 1.0);
        glfw.c.glClear(glfw.c.GL_COLOR_BUFFER_BIT);
        try window.swapBuffers();
    }
}
