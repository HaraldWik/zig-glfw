pub const build_options = @import("build_options");
pub const c = @import("c");
pub const err = @import("err.zig");
pub const native = @import("native.zig");
pub const io = @import("io.zig");
pub const opengl = if (!build_options.none) @import("opengl.zig") else struct {};
pub const vulkan = if (build_options.vulkan) @import("vulkan.zig") else struct {};

pub const Monitor = @import("monitor.zig").Monitor;
pub const Window = @import("window.zig").Window;

pub fn Position(T: type) type {
    return struct {
        x: T,
        y: T,
        pub const Tuple = struct { T, T };
        pub inline fn toTuple(self: @This()) Tuple {
            return .{ self.x, self.y };
        }
    };
}

pub fn Size(T: type) type {
    return struct {
        width: T,
        height: T,

        pub const Tuple = struct { T, T };
        pub inline fn toTuple(self: @This()) Tuple {
            return .{ self.width, self.height };
        }
    };
}

pub const Image = struct {
    width: usize,
    height: usize,
    pixels: [*]u8,

    pub const CType = c.GLFWimage;

    pub inline fn toC(self: @This()) CType {
        return .{
            .width = @intCast(self.width),
            .height = @intCast(self.height),
            .pixels = @ptrCast(self.pixels),
        };
    }
};

pub const Version = struct {
    major: usize,
    minor: usize,
    patch: usize,

    pub fn get() @This() {
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

pub inline fn init() !void {
    // c.glfwInitAllocator();
    if (err.errorFromInt(@intCast(c.glfwInit()))) |e| return e;
}

/// Same as 'glfwTerminate'
pub inline fn deinit() void {
    c.glfwTerminate();
}

//c.glfwGetTime
pub const time = struct {
    pub inline fn get() f64 {
        return c.glfwGetTime();
    }

    pub inline fn set(t: f64) void {
        return c.glfwSetTime(t);
    }

    pub inline fn getTimerValue() u64 {
        return c.glfwGetTimerValue();
    }

    pub inline fn getTimerFrequency() u64 {
        return c.glfwGetTimerFrequency();
    }
};
