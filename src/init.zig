const c = @import("c");
const err = @import("err.zig");

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
    // glfwInitAllocator
    if (err.errorFromInt(@intCast(c.glfwInit()))) |e| return e;
}

/// Same as 'glfwTerminate'
pub inline fn deinit() void {
    c.glfwTerminate();
}
