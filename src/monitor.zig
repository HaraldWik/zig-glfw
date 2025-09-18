const std = @import("std");
const root = @import("root.zig");
const c = @import("c");
const err = @import("err.zig");

pub const VideoMode = struct {
    pub const CType = c.GLFWvidmode;

    width: isize,
    height: isize,
    redBits: isize,
    greenBits: isize,
    blueBits: isize,
    refreshRate: isize,
};

pub const Monitor = *opaque {
    pub const CType = *c.GLFWmonitor;

    pub fn toC(self: *@This()) CType {
        return @ptrCast(self);
    }

    pub fn getPrimary() *@This() {
        return @ptrCast(c.glfwGetPrimaryMonitor());
    }

    pub fn getAll() []*@This() {
        var count: c_int = undefined;
        const monitors = c.glfwGetMonitors(&count);
        return @ptrCast(monitors[0..@intCast(count)]);
    }

    pub fn getPosition(self: *@This()) !root.Position(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetMonitorPos(self.toC(), &x, &y);
        try err.check();
        return .{ .x = x, .y = y };
    }

    pub fn getWorkarea(self: *@This()) !struct { size: root.Size(usize), position: root.Position(usize) } {
        var x: c_int = undefined;
        var y: c_int = undefined;
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetMonitorWorkarea(self.toC(), &x, &y, &width, &height);
        try err.check();
        return .{ .size = .{ .width = @intCast(width), .height = @intCast(height) }, .position = .{ .x = @intCast(x), .y = @intCast(y) } };
    }

    pub fn getPhysicalSize(self: *@This()) !root.Size(usize) {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetMonitorPhysicalSize(self.toC(), &width, &height);
        try err.check();
        return .{ .width = @intCast(width), .height = @intCast(height) };
    }

    pub fn getContentScale(self: *@This()) !root.Size(f32) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetMonitorContentScale(self.toC(), &x, &y);
        try err.check();
        return .{ .width = x, .height = y };
    }

    pub fn getName(self: *@This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetMonitorName(self.toC()));
    }

    pub fn getVideoModes(self: *@This()) []const VideoMode {
        var count: c_int = undefined;
        const video_modes = c.glfwGetVideoModes(self.toC(), &count);
        return @ptrCast(video_modes[0..@intCast(count)]);
    }

    pub fn setGamma(self: *@This()) !void {
        c.glfwSetGamma(self.toC());
        try err.check();
    }

    pub fn getGammaRamp(self: *@This()) *c.GLFWgammaramp {
        return @ptrCast(c.glfwGetGammaRamp(self.toC()));
    }

    pub fn setGammaRamp(self: *@This(), ramp: *c.GLFWgammaramp) void {
        c.glfwSetGammaRamp(self.toC(), @ptrCast(ramp));
    }

    pub fn getUserPtr(self: *@This()) ?*anyopaque {
        return c.glfwGetMonitorUserPointer(self.toC());
    }

    pub fn setUserPtr(self: *@This(), ptr: *anyopaque) !void {
        c.glfwSetMonitorUserPointer(self.toC(), ptr);
        try err.check();
    }
};
