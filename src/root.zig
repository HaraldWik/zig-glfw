pub const build_options = @import("build_options");
pub const c = @import("c");
pub const err = @import("err.zig");
pub const native = @import("native.zig");
pub const io = @import("io.zig");
pub const opengl = if (!build_options.none) @import("opengl.zig") else @compileError("Add '.none = false' in dependency to use opengl module");
pub const vulkan = if (build_options.vulkan) @import("vulkan.zig") else @compileError("Add '.vulkan = true' in dependency to use vulkan module");

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
    width: usize,
    height: usize,
    pixels: [*]u8,

    pub const CType = c.GLFWimage;

    pub fn toC(self: @This()) CType {
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
    mouse_passthrough = c.GLFW_MOUSE_PASSTHROUGH,

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

    pub fn get(self: @This(), window: Window) usize {
        return @intCast(c.glfwGetWindowAttrib(window.toC(), @intFromEnum(self)));
    }

    pub fn set(self: @This(), window: Window, value: bool) !void {
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
        }
        c.glfwSetWindowAttrib(window.toC(), @intFromEnum(self), @intFromBool(value));
        try err.check();
    }
};

pub fn init() !void {
    // c.glfwInitAllocator();
    // c.GLFWallocatefun,
    if (err.errorFromInt(@intCast(c.glfwInit()))) |e| return e;
}

/// Same as 'glfwTerminate'
pub fn deinit() void {
    c.glfwTerminate();
}

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
