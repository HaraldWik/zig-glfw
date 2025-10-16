const std = @import("std");
const root = @import("root.zig");
const c = @import("c");
const err = @import("err.zig");
const io = @import("io.zig");

const Monitor = @import("monitor.zig").Monitor;

pub const Window = opaque {
    pub const CType = *c.GLFWwindow;

    pub const Hint = union(enum) {
        resizable: bool,
        visible: bool,
        decorated: bool,
        red_bits: u8,
        green_bits: u8,
        blue_bits: u8,
        alpha_bits: u8,
        depth_bits: u8,
        stencil_bits: u8,
        accum_red_bits: u8,
        accum_green_bits: u8,
        accum_blue_bits: u8,
        accum_alpha_bits: u8,
        aux_buffers: u8,
        samples: u8,
        refresh_rate: usize,
        stereo: bool,
        srgb_capable: bool,
        client_api: enum(c_int) { opengl = c.GLFW_OPENGL_API, opengl_es = c.GLFW_OPENGL_ES_API, none = 0, _ },
        context_version_major: usize,
        context_version_minor: usize,
        context_robustness: enum(c_int) { no = c.GLFW_NO_ROBUSTNESS, no_reset_notification = c.GLFW_NO_RESET_NOTIFICATION, lose_on_reset = c.GLFW_LOSE_CONTEXT_ON_RESET },
        opengl_forward_compat: bool,
        opengl_debug_context: bool,
        opengl_profile: enum(c_int) { any = c.GLFW_OPENGL_ANY_PROFILE, compatibility = c.GLFW_OPENGL_COMPAT_PROFILE, core = c.GLFW_OPENGL_CORE_PROFILE },

        pub fn toC(self: @This()) c_int {
            return switch (self) {
                .resizable => c.GLFW_RESIZABLE,
                .visible => c.GLFW_VISIBLE,
                .decorated => c.GLFW_DECORATED,
                .red_bits => c.GLFW_RED_BITS,
                .green_bits => c.GLFW_GREEN_BITS,
                .blue_bits => c.GLFW_BLUE_BITS,
                .alpha_bits => c.GLFW_ALPHA_BITS,
                .depth_bits => c.GLFW_DEPTH_BITS,
                .stencil_bits => c.GLFW_STENCIL_BITS,
                .accum_red_bits => c.GLFW_ACCUM_RED_BITS,
                .accum_green_bits => c.GLFW_ACCUM_GREEN_BITS,
                .accum_blue_bits => c.GLFW_ACCUM_BLUE_BITS,
                .accum_alpha_bits => c.GLFW_ACCUM_ALPHA_BITS,
                .aux_buffers => c.GLFW_AUX_BUFFERS,
                .samples => c.GLFW_SAMPLES,
                .refresh_rate => c.GLFW_REFRESH_RATE,
                .stereo => c.GLFW_STEREO,
                .srgb_capable => c.GLFW_SRGB_CAPABLE,
                .client_api => c.GLFW_CLIENT_API,
                .context_version_major => c.GLFW_CONTEXT_VERSION_MAJOR,
                .context_version_minor => c.GLFW_CONTEXT_VERSION_MINOR,
                .context_robustness => c.GLFW_CONTEXT_ROBUSTNESS,
                .opengl_forward_compat => c.GLFW_OPENGL_FORWARD_COMPAT,
                .opengl_debug_context => c.GLFW_OPENGL_DEBUG_CONTEXT,
                .opengl_profile => c.GLFW_OPENGL_PROFILE,
            };
        }

        pub fn set(self: @This()) void {
            switch (self) {
                .resizable => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .visible => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .decorated => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .red_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .green_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .blue_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .alpha_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .depth_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .stencil_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .accum_red_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .accum_green_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .accum_blue_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .accum_alpha_bits => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .aux_buffers => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .samples => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .refresh_rate => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .stereo => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .srgb_capable => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .client_api => |hint| c.glfwWindowHint(self.toC(), @intFromEnum(hint)),
                .context_version_major => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .context_version_minor => |hint| c.glfwWindowHint(self.toC(), @intCast(hint)),
                .context_robustness => |hint| c.glfwWindowHint(self.toC(), @intFromEnum(hint)),
                .opengl_forward_compat => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .opengl_debug_context => |hint| c.glfwWindowHint(self.toC(), @intFromBool(hint)),
                .opengl_profile => |hint| c.glfwWindowHint(self.toC(), @intFromEnum(hint)),
            }
        }
    };

    pub const Attribute = enum(c_int) {
        focused = c.GLFW_FOCUSED,
        iconified = c.GLFW_ICONIFIED,
        maximized = c.GLFW_MAXIMIZED,
        hovered = c.GLFW_HOVERED,
        visible = c.GLFW_VISIBLE,
        resizable = c.GLFW_RESIZABLE,
        decorated = c.GLFW_DECORATED,
        auto_iconify = c.GLFW_AUTO_ICONIFY,
        floating = c.GLFW_FLOATING,
        transparent_framebuffer = c.GLFW_TRANSPARENT_FRAMEBUFFER,
        focus_on_show = c.GLFW_FOCUS_ON_SHOW,

        /// Read-only
        client_api = c.GLFW_CLIENT_API,
        context_creation_api = c.GLFW_CONTEXT_CREATION_API,
        context_version_major = c.GLFW_CONTEXT_VERSION_MAJOR,
        context_version_minor = c.GLFW_CONTEXT_VERSION_MINOR,
        context_revision = c.GLFW_CONTEXT_REVISION,
        opengl_forward_compat = c.GLFW_OPENGL_FORWARD_COMPAT,
        opengl_debug_context = c.GLFW_OPENGL_DEBUG_CONTEXT,
        opengl_profile = c.GLFW_OPENGL_PROFILE,
        context_release_behavior = c.GLFW_CONTEXT_RELEASE_BEHAVIOR,
        context_no_error = c.GLFW_CONTEXT_NO_ERROR,
        context_robustness = c.GLFW_CONTEXT_ROBUSTNESS,

        _,

        pub fn get(self: @This(), window: *Window) usize {
            return @intCast(c.glfwGetWindowAttrib(window.toC(), @intFromEnum(self)));
        }

        pub fn set(self: @This(), window: *Window, value: bool) !void {
            switch (self) {
                .client_api,
                .context_creation_api,
                .context_version_major,
                .context_version_minor,
                .context_revision,
                .opengl_forward_compat,
                .opengl_debug_context,
                .opengl_profile,
                .context_release_behavior,
                .context_no_error,
                .context_robustness,
                => return error.OpenGLReadOnly,
                else => {},
            }
            c.glfwSetWindowAttrib(window.toC(), @intFromEnum(self), @intFromBool(value));
            try err.check();
        }
    };

    pub const Config = struct {
        title: [*:0]const u8,
        size: root.Size(usize),
        monitor: ?*Monitor = null,
        share: ?*Window = null,
    };

    pub fn toC(self: *@This()) CType {
        return @ptrCast(self);
    }

    pub fn init(config: Config) !*@This() {
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

    pub fn getTitle(self: *@This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetWindowTitle(self.toC()));
    }

    pub fn setTitle(self: *@This(), title: [*:0]const u8) !void {
        c.glfwSetWindowTitle(self.toC(), title);
        try err.check();
    }

    pub fn setIcon(self: *@This(), count: usize, image: root.Image) !void {
        c.glfwSetWindowIcon(self.toC(), @intCast(count), @ptrCast(&image.toC()));
        try err.check();
    }

    pub fn getPosition(self: *@This()) !root.Position(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowPos(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub fn setPosition(self: *@This(), pos: root.Position(usize)) !void {
        c.glfwSetWindowPos(self.toC(), @intCast(pos.x), @intCast(pos.y));
        try err.check();
    }

    pub fn getSize(self: *@This()) root.Size(usize) {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetWindowSize(self.toC(), &width, &height);
        return .{ .width = @intCast(width), .height = @intCast(height) };
    }

    pub fn setSize(self: *@This(), size: root.Size(usize)) !void {
        c.glfwSetWindowSize(self.toC(), @intCast(size.width), @intCast(size.height));
        try err.check();
    }

    pub fn setSizeLimit(self: *@This(), min: ?root.Size(usize), max: ?root.Size(usize)) !void {
        c.glfwSetWindowSizeLimits(
            self.toC(),
            if (min != null) @intCast(min.?.width) else c.GLFW_DONT_CARE,
            if (min != null) @intCast(min.?.height) else c.GLFW_DONT_CARE,
            if (max != null) @intCast(max.?.width) else c.GLFW_DONT_CARE,
            if (max != null) @intCast(max.?.height) else c.GLFW_DONT_CARE,
        );
        try err.check();
    }

    pub fn setAspectRatio(self: *@This(), numer: usize, denom: usize) !void {
        c.glfwSetWindowAspectRatio(self.toC(), @intCast(numer), @intCast(denom));
        try err.check();
    }

    pub fn getFramebufferSize(self: *@This()) !root.Size(usize) {
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

    pub fn getContentScale(self: *@This()) !root.Size(usize) {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.glfwGetWindowContentScale(self.toC(), &x, &y);
        try err.check();
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub fn getOpacity(self: *@This()) f32 {
        return c.glfwGetWindowOpacity(self.toC());
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

    pub fn getMonitor(self: *@This()) ?*Monitor {
        return @ptrCast(c.glfwGetWindowMonitor(self.toC()));
    }

    pub fn setMonitor(self: *@This(), monitor: *Monitor, position: root.Position(usize), size: root.Size(usize), refresh_rate: usize) !void {
        c.glfwSetWindowMonitor(self.toC(), monitor.toC(), @intCast(position.x), @intCast(position.y), @intCast(size.width), @intCast(size.height), @intCast(refresh_rate));
        try err.check();
    }

    pub fn getUserPtr(self: *@This()) !*anyopaque {
        const ptr = c.glfwGetWindowUserPointer(self.toC()) orelse return error.GetWindowUserPointer;
        try err.check();
        return ptr;
    }

    pub fn setUserPtr(self: *@This(), ptr: *anyopaque) !void {
        c.glfwSetWindowUserPointer(self.toC(), ptr);
        try err.check();
    }
};
