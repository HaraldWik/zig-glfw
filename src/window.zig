const std = @import("std");
const root = @import("root.zig");
const c = @import("c");
const err = @import("err.zig");
const io = @import("io.zig");

const Monitor = @import("monitor.zig").Monitor;

pub const Image = c.GLFWimage;

pub const Window = *opaque {
    pub const CType = *c.GLFWwindow;

    pub const Config = struct {
        title: [*:0]const u8,
        size: root.Size(usize),
        monitor: ?Monitor = null,
        share: ?Window = null,
        hints: struct {
            resizable: ?bool = null,
            visible: ?bool = null,
            decorated: ?bool = null,
            focused: ?bool = null,
            auto_iconify: ?bool = null,
            floating: ?bool = null,
            maximized: ?bool = null,
            center_cursor: ?bool = null,
            transparent_framebuffer: ?bool = null,
            focus_on_show: ?bool = null,
            scale_to_monitor: ?bool = null,
            red_bits: ?bool = null,
            green_bits: ?bool = null,
            blue_bits: ?bool = null,
            alpha_bits: ?bool = null,
            depth_bits: ?bool = null,
            stencil_bits: ?bool = null,
            accum_red_bits: ?bool = null,
            accum_green_bits: ?bool = null,
            accum_blue_bits: ?bool = null,
            accum_alpha_bits: ?bool = null,
            aux_buffers: ?bool = null,
            stereo: ?bool = null,
            samples: ?bool = null,
            srgb_capable: ?bool = null,
            doublebuffer: ?bool = null,
            client_api: ?bool = null,
            context_version_major: ?bool = null,
            context_version_minor: ?bool = null,
            opengl_forward_compat: ?bool = null,
            opengl_debug_context: ?bool = null,
            opengl_profile: ?bool = null,
            context_robustness: ?bool = null,
            context_release_behavior: ?bool = null,
            context_no_error: ?bool = null,
        } = .{},
    };

    pub inline fn toC(self: *@This()) CType {
        return @ptrCast(self);
    }

    pub fn init(config: Config) !*@This() {
        if (config.hints.resizable) |hint| c.glfwWindowHint(c.GLFW_RESIZABLE, @intFromBool(hint));
        if (config.hints.visible) |hint| c.glfwWindowHint(c.GLFW_VISIBLE, @intFromBool(hint));
        if (config.hints.decorated) |hint| c.glfwWindowHint(c.GLFW_DECORATED, @intFromBool(hint));
        if (config.hints.focused) |hint| c.glfwWindowHint(c.GLFW_FOCUSED, @intFromBool(hint));
        if (config.hints.auto_iconify) |hint| c.glfwWindowHint(c.GLFW_AUTO_ICONIFY, @intFromBool(hint));
        if (config.hints.floating) |hint| c.glfwWindowHint(c.GLFW_FLOATING, @intFromBool(hint));
        if (config.hints.maximized) |hint| c.glfwWindowHint(c.GLFW_MAXIMIZED, @intFromBool(hint));
        if (config.hints.center_cursor) |hint| c.glfwWindowHint(c.GLFW_CENTER_CURSOR, @intFromBool(hint));
        if (config.hints.transparent_framebuffer) |hint| c.glfwWindowHint(c.GLFW_TRANSPARENT_FRAMEBUFFER, @intFromBool(hint));
        if (config.hints.focus_on_show) |hint| c.glfwWindowHint(c.GLFW_FOCUS_ON_SHOW, @intFromBool(hint));
        if (config.hints.scale_to_monitor) |hint| c.glfwWindowHint(c.GLFW_SCALE_TO_MONITOR, @intFromBool(hint));
        if (config.hints.red_bits) |hint| c.glfwWindowHint(c.GLFW_RED_BITS, @intFromBool(hint));
        if (config.hints.green_bits) |hint| c.glfwWindowHint(c.GLFW_GREEN_BITS, @intFromBool(hint));
        if (config.hints.blue_bits) |hint| c.glfwWindowHint(c.GLFW_BLUE_BITS, @intFromBool(hint));
        if (config.hints.alpha_bits) |hint| c.glfwWindowHint(c.GLFW_ALPHA_BITS, @intFromBool(hint));
        if (config.hints.depth_bits) |hint| c.glfwWindowHint(c.GLFW_DEPTH_BITS, @intFromBool(hint));
        if (config.hints.stencil_bits) |hint| c.glfwWindowHint(c.GLFW_STENCIL_BITS, @intFromBool(hint));
        if (config.hints.accum_red_bits) |hint| c.glfwWindowHint(c.GLFW_ACCUM_RED_BITS, @intFromBool(hint));
        if (config.hints.accum_green_bits) |hint| c.glfwWindowHint(c.GLFW_ACCUM_GREEN_BITS, @intFromBool(hint));
        if (config.hints.accum_blue_bits) |hint| c.glfwWindowHint(c.GLFW_ACCUM_BLUE_BITS, @intFromBool(hint));
        if (config.hints.accum_alpha_bits) |hint| c.glfwWindowHint(c.GLFW_ACCUM_ALPHA_BITS, @intFromBool(hint));
        if (config.hints.aux_buffers) |hint| c.glfwWindowHint(c.GLFW_AUX_BUFFERS, @intFromBool(hint));
        if (config.hints.stereo) |hint| c.glfwWindowHint(c.GLFW_STEREO, @intFromBool(hint));
        if (config.hints.samples) |hint| c.glfwWindowHint(c.GLFW_SAMPLES, @intFromBool(hint));
        if (config.hints.srgb_capable) |hint| c.glfwWindowHint(c.GLFW_SRGB_CAPABLE, @intFromBool(hint));
        if (config.hints.doublebuffer) |hint| c.glfwWindowHint(c.GLFW_DOUBLEBUFFER, @intFromBool(hint));
        if (config.hints.client_api) |hint| c.glfwWindowHint(c.GLFW_CLIENT_API, @intFromBool(hint));
        if (config.hints.context_version_major) |hint| c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, @intFromBool(hint));
        if (config.hints.context_version_minor) |hint| c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, @intFromBool(hint));
        if (config.hints.opengl_forward_compat) |hint| c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, @intFromBool(hint));
        if (config.hints.opengl_debug_context) |hint| c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, @intFromBool(hint));
        if (config.hints.opengl_profile) |hint| c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, @intFromBool(hint));
        if (config.hints.context_robustness) |hint| c.glfwWindowHint(c.GLFW_CONTEXT_ROBUSTNESS, @intFromBool(hint));
        if (config.hints.context_release_behavior) |hint| c.glfwWindowHint(c.GLFW_CONTEXT_RELEASE_BEHAVIOR, @intFromBool(hint));
        if (config.hints.context_no_error) |hint| c.glfwWindowHint(c.GLFW_CONTEXT_NO_ERROR, @intFromBool(hint));

        const window = c.glfwCreateWindow(
            @intCast(config.size.width),
            @intCast(config.size.height),
            config.title,
            if (config.monitor) |monitor| monitor.toC() else null,
            if (config.share) |share| share.toC() else null,
        ) orelse return error.CreateWindow;

        try err.check();

        return @ptrCast(window);
    }

    pub inline fn deinit(self: *@This()) void {
        c.glfwDestroyWindow(self.toC());
    }

    pub inline fn shouldClose(self: *@This()) bool {
        return c.glfwWindowShouldClose(self.toC()) == c.GLFW_TRUE;
    }

    pub inline fn setShouldClose(self: *@This(), value: bool) void {
        c.glfwSetWindowShouldClose(self.toC(), @intFromBool(value));
    }

    pub inline fn getTitle(self: *@This()) ![*:0]const u8 {
        return c.glfwGetWindowTitle(self.toC()) orelse error.GetWindowTitle;
    }

    pub inline fn setTitle(self: *@This(), title: [*:0]const u8) !void {
        c.glfwSetWindowTitle(self.toC(), title);
        try err.check();
    }

    pub inline fn setIcon(self: *@This(), count: usize, images: []const Image) !void {
        c.glfwSetWindowIcon(self.toC(), @intCast(count), @ptrCast(images));
        try err.check();
    }

    pub inline fn getPosition(self: *@This()) !root.Position(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowPos(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub inline fn setPosition(self: *@This(), pos: root.Position(usize)) !void {
        c.glfwSetWindowPos(self.toC(), @intCast(pos.x), @intCast(pos.y));
        try err.check();
    }

    pub inline fn getSize(self: *@This()) !root.Size(usize) {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetWindowSize(self.toC(), &width, &height);
        try err.check();
        return .{ .widht = @intCast(width), .height = @intCast(height) };
    }

    pub inline fn setSize(self: *@This(), size: root.Size(usize)) !void {
        c.glfwSetWindowSize(self.toC(), @intCast(size.width), @intCast(size.height));
        try err.check();
    }

    pub inline fn setSizeLimit(self: *@This(), min: root.Size(usize), max: root.Size(usize)) !void {
        c.glfwSetWindowSizeLimits(self.toC(), @intCast(min.width), @intCast(min.height), @intCast(max.width), @intCast(max.height));
        try err.check();
    }

    pub inline fn setAspectRatio(self: *@This(), numer: usize, denom: usize) !void {
        c.glfwSetWindowAspectRatio(self.toC(), @intCast(numer), @intCast(denom));
        try err.check();
    }

    pub inline fn getFramebufferSize(self: *@This()) !root.Size {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetFramebufferSize(self.toC(), &width, &height);
        try err.check();
        return .{ .width = @intCast(width), .height = @intCast(height) };
    }

    pub inline fn getWindowFrameSize(self: *@This()) !struct { left: usize, top: usize, right: usize, bottom: usize } {
        var left: c_int = undefined;
        var top: c_int = undefined;
        var right: c_int = undefined;
        var bottom: c_int = undefined;
        c.glfwGetWindowFrameSize(self.toC(), &left, &top, &right, &bottom);
        try err.check();
        return .{ .left = @intCast(left), .top = @intCast(top), .right = @intCast(right), .bottom = @intCast(bottom) };
    }

    pub inline fn getContentScale(self: *@This()) !root.Size(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowContentScale(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub inline fn getOpacity(self: *@This()) !f32 {
        const opacity = c.glfwGetWindowOpacity(self.toC());
        try err.check();
        return opacity;
    }

    pub inline fn setOpacity(self: *@This(), opacity: f32) !void {
        c.glfwSetWindowOpacity(self.toC(), opacity);
        try err.check();
    }

    pub inline fn iconify(self: *@This()) !void {
        c.glfwIconifyWindow(self.toC());
        try err.check();
    }

    pub inline fn restore(self: *@This()) !void {
        c.glfwRestoreWindow(self.toC());
        try err.check();
    }

    pub inline fn maximize(self: *@This()) !void {
        c.glfwMaximizeWindow(self.toC());
        try err.check();
    }

    pub inline fn show(self: *@This()) !void {
        c.glfwShowWindow(self.toC());
        try err.check();
    }

    pub inline fn hide(self: *@This()) !void {
        c.glfwHideWindow(self.toC());
        try err.check();
    }

    pub inline fn focus(self: *@This()) !void {
        c.glfwFocusWindow(self.toC());
        try err.check();
    }

    pub inline fn requestAttention(self: *@This()) !void {
        c.glfwRequestWindowAttention(self.toC());
        try err.check();
    }

    pub inline fn getMonitor(self: *@This()) !*Monitor {
        const monitor = c.glfwGetWindowMonitor(self.toC()) orelse return error.GetMonitor;
        try err.check();
        return monitor;
    }

    pub inline fn setMonitor(self: *@This(), monitor: *Monitor, position: root.Position(usize), size: root.Size(usize), refresh_rate: usize) !void {
        c.glfwSetWindowMonitor(self.toC(), monitor.toC(), @intCast(position.x), @intCast(position.y), @intCast(size.width), @intCast(size.height), @intCast(refresh_rate));
        try err.check();
    }

    // TODO: Add attribute type
    pub inline fn getAttribute(self: *@This(), attribute: usize) !usize {
        const a = c.glfwGetWindowAttrib(self.toC(), @intCast(attribute));
        try err.check();
        return @intCast(a);
    }

    // TODO: Add attribute type
    pub inline fn setAttribute(self: *@This(), attribute: usize, value: usize) !void {
        c.glfwSetWindowAttrib(self.toC(), @intCast(attribute), @intCast(value));
        try err.check();
    }

    pub inline fn getUserPointer(self: *@This()) !*anyopaque {
        const ptr = c.glfwGetWindowUserPointer(self.toC()) orelse return error.GetWindowUserPointer;
        try err.check();
        return ptr;
    }

    pub inline fn setUserPointer(self: *@This(), ptr: *anyopaque) !void {
        c.glfwSetWindowUserPointer(self.toC(), ptr);
        try err.check();
    }
};
