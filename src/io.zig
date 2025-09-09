const build_options = @import("build_options");
const c = @import("c");
const err = @import("err.zig");

pub const events = struct {
    pub inline fn poll() void {
        c.glfwPollEvents();
    }

    pub inline fn wait() void {
        c.glfwWaitEvents();
    }

    pub inline fn waitTimeout(timeout: f64) void {
        c.glfwWaitEventsTimeout(timeout);
    }

    pub inline fn sostEmpty() void {
        c.glfwPostEmptyEvent();
    }
};

pub const MouseButton = enum(c_int) {
    left = c.GLFW_MOUSE_BUTTON_LEFT,
    middle = c.GLFW_MOUSE_BUTTON_MIDDLE,
    right = c.GLFW_MOUSE_BUTTON_RIGHT,
    @"1" = c.GLFW_MOUSE_BUTTON_1,
    @"2" = c.GLFW_MOUSE_BUTTON_2,
    @"3" = c.GLFW_MOUSE_BUTTON_3,
    @"4" = c.GLFW_MOUSE_BUTTON_4,
    @"5" = c.GLFW_MOUSE_BUTTON_5,
    @"6" = c.GLFW_MOUSE_BUTTON_6,
    @"7" = c.GLFW_MOUSE_BUTTON_7,
    @"8" = c.GLFW_MOUSE_BUTTON_8,
};

pub inline fn rawMouseMotionSupported() bool {
    return c.glfwRawMouseMotionSupported() == c.GLFW_TRUE;
}

// TODO: glfwGetKeyName
// TODO: glfwGetKeyScancode
