const std = @import("std");

pub const build_options = @import("build_options");
pub const c = @import("c");
pub const err = @import("err.zig");
pub const native = @import("native.zig");
pub const io = @import("io.zig");
pub const opengl = if (!build_options.none) @import("opengl.zig") else @compileError("add '.none = false' in dependency to use opengl module");
pub const vulkan = if (build_options.vulkan) @import("vulkan.zig") else @compileError("add '.vulkan = true' in dependency to use vulkan module");

pub const Monitor = @import("monitor.zig").Monitor;
pub const Window = @import("window.zig").Window;

pub fn Position(T: type) type {
    return struct {
        x: T,
        y: T,

        pub fn toArray(self: @This()) [2]T {
            return .{ self.x, self.y };
        }
    };
}

pub fn Size(T: type) type {
    return struct {
        width: T,
        height: T,

        pub fn toArray(self: @This()) [2]T {
            return .{ self.width, self.height };
        }
    };
}

pub const Image = struct {
    size: Size(usize),
    pixels: [*]u8,

    pub const CType = c.GLFWimage;

    pub fn toC(self: @This()) CType {
        return .{
            .width = @intCast(self.size.width),
            .height = @intCast(self.size.height),
            .pixels = @ptrCast(self.pixels),
        };
    }
};

pub const version = struct {
    pub fn get() std.SemanticVersion {
        var major: c_int = undefined;
        var minor: c_int = undefined;
        var patch: c_int = undefined;
        c.glfwGetVersion(&major, &minor, &patch);

        return .{ .major = @intCast(major), .minor = @intCast(minor), .patch = @intCast(patch) };
    }

    pub fn getStr() [*:0]const u8 {
        return @ptrCast(c.glfwGetVersionString());
    }
};

pub const time = struct {
    pub fn get() f64 {
        return c.glfwGetTime();
    }

    pub fn set(t: f64) void {
        return c.glfwSetTime(t);
    }

    pub fn getTimerValue() u64 {
        return c.glfwGetTimerValue();
    }

    pub fn getTimerFrequency() u64 {
        return c.glfwGetTimerFrequency();
    }
};

pub fn init() !void {
    // c.glfwInitAllocator();
    // c.GLFWallocatefun,
    if (err.errorFromInt(@intCast(c.glfwInit()))) |e| return e;
    c.glfwSetErrorCallback(err.callback);
    try err.check();
}

/// Same as 'glfwTerminate'
pub fn deinit() void {
    c.glfwTerminate();
}
