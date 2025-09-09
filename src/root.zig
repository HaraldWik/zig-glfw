pub const build_options = @import("build_options");
pub const c = @import("c");
pub const err = @import("err.zig");
pub const init = @import("init.zig");
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
