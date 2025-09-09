const std = @import("std");
const root = @import("root.zig");
const c = @import("c");
const err = @import("err.zig");

pub const Monitor = *opaque {
    pub const CType = c.GLFWmonitor;

    pub inline fn toC(self: *@This()) *CType {
        return @ptrCast(self);
    }

    pub inline fn getPrimary() *@This() {
        return @ptrCast(c.glfwGetPrimaryMonitor());
    }

    pub inline fn getAll() []*@This() {
        var count: c_int = undefined;
        const monitors = c.glfwGetMonitors(&count);
        return @ptrCast(monitors[0..@intCast(count)]);
    }

    pub inline fn getPosition(self: *@This()) !root.Position(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetMonitorPos(self.toC(), &x, &y);
        try err.check();
        return .{ .x = x, .y = y };
    }

    pub inline fn getWorkarea(self: *@This()) !struct { size: root.Size(usize), position: root.Position(usize) } {
        var x: c_int = undefined;
        var y: c_int = undefined;
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetMonitorWorkarea(self.toC(), &x, &y, &width, &height);
        try err.check();
        return .{ .size = .{ .width = @intCast(width), .height = @intCast(height) }, .position = .{ .x = @intCast(x), .y = @intCast(y) } };
    }

    pub inline fn getPhysicalSize(self: *@This()) !root.Size(usize) {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetMonitorPhysicalSize(self.toC(), &width, &height);
        try err.check();
        return .{ .width = @intCast(width), .height = @intCast(height) };
    }

    pub inline fn getContentScale(self: *@This()) !root.Size(f32) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetMonitorContentScale(self.toC(), &x, &y);
        try err.check();
        return .{ .width = x, .height = y };
    }

    pub inline fn getName(self: *@This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetMonitorName(self.toC()));
    }

    pub inline fn getUserPointer(self: *@This()) ?*anyopaque {
        return c.glfwGetMonitorUserPointer(self.toC());
    }

    pub inline fn setUserPointer(self: *@This(), ptr: *anyopaque) !void {
        c.glfwSetMonitorUserPointer(self.toC(), ptr);
        try err.check();
    }

    // TODO: add glfwGetVideoModes
    // TODO: add glfwGetVideoMode
    // TODO: add glfwSetGamma
    // TODO: add glfwGetGammaRamp
    // TODO: add glfwSetGammaRamp
};
