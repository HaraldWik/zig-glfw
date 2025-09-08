pub const c = @import("c");
pub const err = @import("err.zig");

pub inline fn init() !void {
    if (err.errorFromInt(@intCast(c.glfwInit()))) |e| return e;
}

/// Same as 'glfwTerminate'
pub inline fn deinit() void {
    c.glfwTerminate();
}

pub inline fn pollEvents() void {
    c.glfwPollEvents();
}

pub const Image = c.GLFWimage;

pub const Monitor = opaque {
    pub const CType = c.GLFWmonitor;

    pub inline fn toC(self: *@This()) *CType {
        return @ptrCast(self);
    }
};

pub const Window = opaque {
    pub const CType = c.GLFWwindow;

    pub const Position = struct {
        x: usize,
        y: usize,
        pub const Tuple = struct { usize, usize };
        pub inline fn toTuple(self: @This()) Tuple {
            return .{ self.x, self.y };
        }
    };

    pub const Size = struct {
        width: usize,
        height: usize,

        pub const Tuple = struct { usize, usize };
        pub inline fn toTuple(self: @This()) Tuple {
            return .{ self.width, self.height };
        }
    };

    pub const Scale = struct {
        x: usize,
        y: usize,
        pub const Tuple = struct { usize, usize };
        pub inline fn toTuple(self: @This()) Tuple {
            return .{ self.x, self.y };
        }
    };

    pub const Mouse = struct {
        position: struct { f64, f64 },
        left: bool,
        middle: bool,
        right: bool,
        @"1": bool,
        @"2": bool,
        @"3": bool,
        @"4": bool,
        @"5": bool,
        @"6": bool,
        @"7": bool,
        @"8": bool,
    };

    pub const Config = struct {
        title: [*:0]const u8,
        size: Size,
        monitor: ?*Monitor = null,
        share: ?*Window = null,
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

    pub inline fn toC(self: *@This()) *CType {
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

    pub fn deinit(self: *@This()) void {
        c.glfwDestroyWindow(self.toC());
    }

    pub fn shouldClose(self: *@This()) bool {
        return c.glfwWindowShouldClose(self.toC()) == c.GLFW_TRUE;
    }

    pub fn setShouldClose(self: *@This(), value: bool) void {
        c.glfwSetWindowShouldClose(self.toC(), @intFromBool(value));
    }

    pub fn getTitle(self: *@This()) ![*:0]const u8 {
        return c.glfwGetWindowTitle(self.toC()) orelse error.GetWindowTitle;
    }

    pub fn setTitle(self: *@This(), title: [*:0]const u8) !void {
        c.glfwSetWindowTitle(self.toC(), title);
        try err.check();
    }

    pub fn setIcon(self: *@This(), count: usize, images: []const Image) !void {
        c.glfwSetWindowIcon(self.toC(), @intCast(count), @ptrCast(images));
        try err.check();
    }

    pub fn getPosition(self: *@This()) !Position {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowPos(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub fn setPosition(self: *@This(), pos: Position) !void {
        c.glfwSetWindowPos(self.toC(), @intCast(pos.x), @intCast(pos.y));
        try err.check();
    }

    pub fn getSize(self: *@This()) !Size {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetWindowSize(self.toC(), &width, &height);
        try err.check();
        return .{ .widht = @intCast(width), .height = @intCast(height) };
    }

    pub fn setSize(self: *@This(), size: Size) !void {
        c.glfwSetWindowSize(self.toC(), @intCast(size.width), @intCast(size.height));
        try err.check();
    }

    pub fn setSizeLimit(self: *@This(), min: Size, max: Size) !void {
        c.glfwSetWindowSizeLimits(self.toC(), @intCast(min.width), @intCast(min.height), @intCast(max.width), @intCast(max.height));
        try err.check();
    }

    pub fn setAspectRatio(self: *@This(), numer: usize, denom: usize) !void {
        c.glfwSetWindowAspectRatio(self.toC(), @intCast(numer), @intCast(denom));
        try err.check();
    }

    pub fn getFramebufferSize(self: *@This()) !Size {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetFramebufferSize(self.toC(), &width, &height);
        try err.check();
        return .{ .width = @intCast(width), .height = @intCast(height) };
    }

    pub fn getWindowFrameSize(self: *@This()) !struct { left: usize, top: usize, right: usize, bottom: usize } {
        var left: c_int = undefined;
        var top: c_int = undefined;
        var right: c_int = undefined;
        var bottom: c_int = undefined;
        c.glfwGetWindowFrameSize(self.toC(), &left, &top, &right, &bottom);
        try err.check();
        return .{ .left = @intCast(left), .top = @intCast(top), .right = @intCast(right), .bottom = @intCast(bottom) };
    }

    pub fn getContentScale(self: *@This()) !Scale {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowContentScale(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub fn getOpacity(self: *@This()) !f32 {
        const opacity = c.glfwGetWindowOpacity(self.toC());
        try err.check();
        return opacity;
    }

    pub fn setOpacity(self: *@This(), opacity: f32) !void {
        c.glfwSetWindowOpacity(self.toC(), opacity);
        try err.check();
    }

    pub fn iconify(self: *@This()) !void {
        c.glfwIconifyWindow(self.toC());
        try err.check();
    }

    pub fn restore(self: *@This()) !void {
        c.glfwRestoreWindow(self.toC());
        try err.check();
    }

    pub fn maximize(self: *@This()) !void {
        c.glfwMaximizeWindow(self.toC());
        try err.check();
    }

    pub fn show(self: *@This()) !void {
        c.glfwShowWindow(self.toC());
        try err.check();
    }

    pub fn hide(self: *@This()) !void {
        c.glfwHideWindow(self.toC());
        try err.check();
    }

    pub fn focus(self: *@This()) !void {
        c.glfwFocusWindow(self.toC());
        try err.check();
    }

    pub fn requestAttention(self: *@This()) !void {
        c.glfwRequestWindowAttention(self.toC());
        try err.check();
    }

    pub fn getMonitor(self: *@This()) !*Monitor {
        const monitor = c.glfwGetWindowMonitor(self.toC()) orelse return error.GetMonitor;
        try err.check();
        return monitor;
    }

    pub fn setMonitor(self: *@This(), monitor: *Monitor, position: Position, size: Size, refresh_rate: usize) !void {
        c.glfwSetWindowMonitor(self.toC(), monitor.toC(), @intCast(position.x), @intCast(position.y), @intCast(size.width), @intCast(size.height), @intCast(refresh_rate));
        try err.check();
    }

    // TODO: Add attribute type
    pub fn getAttribute(self: *@This(), attribute: usize) !usize {
        const a = c.glfwGetWindowAttrib(self.toC(), @intCast(attribute));
        try err.check();
        return @intCast(a);
    }

    // TODO: Add attribute type
    pub fn setAttribute(self: *@This(), attribute: usize, value: usize) !void {
        c.glfwSetWindowAttrib(self.toC(), @intCast(attribute), @intCast(value));
        try err.check();
    }

    pub fn getUserPointer(self: *@This()) !*anyopaque {
        const ptr = c.glfwGetWindowUserPointer(self.toC()) orelse return error.GetWindowUserPointer;
        try err.check();
        return ptr;
    }

    pub fn setUserPointer(self: *@This(), ptr: *anyopaque) !void {
        c.glfwSetWindowUserPointer(self.toC(), ptr);
        try err.check();
    }

    pub fn getInputMode(self: *@This(), mode: usize) !usize {
        const m = c.glfwGetInputMode(self.toC(), @intCast(mode));
        try err.check();
        return @intCast(m);
    }

    pub fn setInputMode(self: *@This(), mode: usize, value: usize) !void {
        c.glfwSetInputMode(self.toC(), @intCast(mode), @intCast(value));
        try err.check();
    }

    // TODO: Add dedicated key type
    pub fn getKey(self: *@This(), key: usize) bool {
        return c.glfwGetKey(self.toC(), @intCast(key)) == c.GLFW_TRUE;
    }

    // TODO: Reword mouse
    pub fn getMouse(self: *@This()) !Mouse {
        var x: f64 = undefined;
        var y: f64 = undefined;
        c.glfwGetCursorPos(self.toC(), &x, &y);
        try err.check();
        return .{
            .position = .{ x, y },
            .left = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_LEFT) == c.GLFW_TRUE,
            .middle = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_MIDDLE) == c.GLFW_TRUE,
            .right = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_RIGHT) == c.GLFW_TRUE,
            .@"1" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_1) == c.GLFW_TRUE,
            .@"2" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_2) == c.GLFW_TRUE,
            .@"3" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_3) == c.GLFW_TRUE,
            .@"4" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_4) == c.GLFW_TRUE,
            .@"5" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_5) == c.GLFW_TRUE,
            .@"6" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_6) == c.GLFW_TRUE,
            .@"7" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_7) == c.GLFW_TRUE,
            .@"8" = c.glfwGetMouseButton(self.toC(), c.GLFW_MOUSE_BUTTON_8) == c.GLFW_TRUE,
        };
    }

    // glfwSetCursorPos <-- Next up
};
