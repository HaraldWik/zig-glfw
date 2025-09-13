const std = @import("std");
const builtin = @import("builtin");
const c = @import("c");
const err = @import("err.zig");
const Window = @import("window.zig").Window;

pub const APIENTRY: std.builtin.CallingConvention = if (builtin.os.tag == .windows) .winapi else .c;

pub fn getProcAddress(proc_name: [*:0]const u8) ?*const fn () callconv(APIENTRY) void {
    return c.glfwGetProcAddress(@ptrCast(proc_name));
}

pub fn extensionSupported(extension: [*:0]const u8) bool {
    return c.glfwExtensionSupported(@ptrCast(extension)) == c.GLFW_TRUE;
}

pub fn makeContextCurrent(window: ?Window) void {
    c.glfwMakeContextCurrent(if (window) |_| window.?.toC() else null);
}

pub fn swapBuffers(window: Window) !void {
    c.glfwSwapBuffers(window.toC());
    try err.check();
}

pub fn swapInterval(interval: usize) void {
    c.glfwSwapInterval(@intCast(interval));
}
