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

    while (!window.shouldClose()) {
        glfw.pollEvents();
        glfw.c.glClearColor(0.1, 0.5, 0.3, 1.0);
        glfw.c.glClear(glfw.c.GL_COLOR_BUFFER_BIT);
        glfw.c.glfwSwapBuffers(window.toC());
    }
}
