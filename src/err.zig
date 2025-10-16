const std = @import("std");
const c = @import("c");

pub fn callback(code: c_int, desc: [*:0]const u8) callconv(.c) void {
    std.log.err("{d}: {s}", .{ code, desc });
}

pub fn getError() struct { usize, ?[*:0]const u8 } {
    var description: [*c]const u8 = undefined;
    const code = c.glfwGetError(&description);
    return .{ @intCast(code), description };
}

/// Internally helper function to convert glfw error code to error type
pub fn errorFromInt(code: usize) ?anyerror {
    return switch (code) {
        c.GLFW_NOT_INITIALIZED => error.NotInitialized,
        c.GLFW_NO_CURRENT_CONTEXT => error.NoCurrentContext,
        c.GLFW_INVALID_ENUM => error.InvalidEnum,
        c.GLFW_INVALID_VALUE => error.InvalidValue,
        c.GLFW_OUT_OF_MEMORY => error.OutOfMemory,
        c.GLFW_API_UNAVAILABLE => error.ApiUnavailable,
        c.GLFW_VERSION_UNAVAILABLE => error.VersionUnavailable,
        c.GLFW_PLATFORM_ERROR => error.PlatformError,
        c.GLFW_FORMAT_UNAVAILABLE => error.FormatUnavailable,
        c.GLFW_NO_WINDOW_CONTEXT => error.NoWindowContext,
        c.GLFW_NO_ERROR => null,
        else => null,
    };
}

pub fn check() !void {
    const code: usize, const description: ?[*:0]const u8 = getError();
    const err = errorFromInt(code) orelse return;
    if (description) |desc| std.log.err("glfw: {s}", .{desc});
    return err;
}
