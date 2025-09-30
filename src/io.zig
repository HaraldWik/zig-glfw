const build_options = @import("build_options");
const c = @import("c");
const err = @import("err.zig");
const root = @import("root.zig");

pub const Mode = enum(c_int) {
    cursor = c.GLFW_CURSOR,
    sticky_keys = c.GLFW_STICKY_KEYS,
    sticky_mouse_buttons = c.GLFW_STICKY_MOUSE_BUTTONS,
    lock_key_mods = c.GLFW_LOCK_KEY_MODS,
    raw_mouse_motion = c.GLFW_RAW_MOUSE_MOTION,

    pub fn get(self: @This(), window: *root.Window) usize {
        return @intCast(c.glfwGetInputMode(window.toC(), @intFromEnum(self)));
    }

    pub fn set(self: @This(), window: *root.Window, value: usize) void {
        c.glfwSetInputMode(window.toC(), @intFromEnum(self), @intCast(value));
    }
};

pub const events = struct {
    pub fn poll() void {
        c.glfwPollEvents();
    }

    pub fn wait() void {
        c.glfwWaitEvents();
    }

    pub fn waitTimeout(timeout: f64) void {
        c.glfwWaitEventsTimeout(timeout);
    }

    pub fn postEmpty() void {
        c.glfwPostEmptyEvent();
    }
};

pub const mouse = struct {
    pub const Button = enum(c_int) {
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

        pub fn get(button: @This(), window: *root.Window) bool {
            return c.glfwGetMouseButton(window.toC(), @intFromEnum(button)) == c.GLFW_TRUE;
        }
    };

    pub fn rawSupported() bool {
        (*Cursor).Shape;

        return c.glfwRawMouseMotionSupported() == c.GLFW_TRUE;
    }

    pub const Cursor = opaque {
        pub const CType = *c.GLFWcursor;

        pub const Shape = enum(c_int) {
            arrow = c.GLFW_ARROW_CURSOR,
            ibeam = c.GLFW_IBEAM_CURSOR,
            crosshair = c.GLFW_CROSSHAIR_CURSOR,
            hand = c.GLFW_HAND_CURSOR,
            hresize = c.GLFW_HRESIZE_CURSOR,
            vresize = c.GLFW_VRESIZE_CURSOR,
        };

        pub fn toC(self: *@This()) CType {
            return @ptrCast(self);
        }

        pub fn init(@"type": union(enum) { standard: Shape, custom: struct { image: root.Image, hotspot: root.Position(usize) } }) !*@This() {
            const cursor = switch (@"type") {
                .standard => |shape| c.glfwCreateStandardCursor(@intFromEnum(shape)),
                .custom => |custom| c.glfwCreateCursor(@ptrCast(&custom.image.toC()), custom.hotspot.x, custom.hotspot.y),
            };
            try err.check();
            return @ptrCast(cursor orelse return error.CreateCursor);
        }

        pub fn deinit(self: *@This()) void {
            c.glfwDestroyCursor(self.toC());
        }

        pub fn set(self: *@This(), window: *root.Window) void {
            c.glfwSetCursor(window.toC(), self.toC());
        }

        pub fn getPosition(window: *root.Window) root.Position(f64) {
            var x: f64 = undefined;
            var y: f64 = undefined;
            c.glfwGetCursorPos(window.toC(), &x, &y);
            return .{ .x = x, .y = y };
        }

        pub fn setPosition(window: *root.Window, position: root.Position(f64)) !void {
            c.glfwSetCursorPos(window.toC(), @intCast(position.x), @intCast(position.y));
            try err.check();
        }
    };
};

pub const Joystick = enum(c_int) {
    @"1" = 0,
    @"2" = 1,
    @"3" = 2,
    @"4" = 3,
    @"5" = 4,
    @"6" = 5,
    @"7" = 6,
    @"8" = 7,
    @"9" = 8,
    @"10" = 9,
    @"11" = 11,
    @"12" = 12,
    @"13" = 13,
    @"14" = 14,
    @"15" = 15,
    @"16" = 16,
    _,

    pub fn present(self: @This()) bool {
        return c.glfwJoystickPresent(@intFromEnum(self)) == c.GLFW_TRUE;
    }

    pub fn isGamepad(self: @This()) bool {
        return c.glfwJoystickIsGamepad(@intFromEnum(self)) == c.GLFW_TRUE;
    }

    pub fn getName(self: @This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetJoystickName(@intFromEnum(self)));
    }

    pub fn getGuid(self: @This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetJoystickGUID(@intFromEnum(self)));
    }

    pub fn getAxes(self: @This()) !?[]const f32 {
        var count: c_int = undefined;
        const axes = c.glfwGetJoystickAxes(@intFromEnum(self), &count);
        try err.check();
        return if (count <= 0 or axes == null) null else @ptrCast(axes[0..@intCast(count)]);
    }

    pub fn getButtons(self: @This()) []const u8 {
        var count: c_int = undefined;
        const buttons = c.glfwGetJoystickButtons(@ptrCast(self), &count);
        return @ptrCast(buttons[0..@intCast(count)]);
    }

    pub fn getHats(self: @This()) []const u8 {
        var count: c_int = undefined;
        const hats = c.glfwGetJoystickHats(@ptrCast(self), &count);
        return @ptrCast(hats[0..@intCast(count)]);
    }

    pub fn setUserPtr(self: @This(), ptr: *anyopaque) !void {
        c.glfwSetJoystickUserPointer(@intFromEnum(self), ptr);
        try err.check();
    }

    pub fn getUserPtr(self: @This()) !?*anyopaque {
        const ptr = c.glfwGetJoystickUserPointer(@intFromEnum(self)) orelse return null;
        try err.check();
        return ptr;
    }
};

pub const Gamepad = enum(c_int) {
    _,

    pub const State = struct {
        pub const CType = c.GLFWgamepadstate;

        axis: struct {
            left_x: f32,
            left_y: f32,
            right_x: f32,
            right_y: f32,
            left_trigger: f32,
            right_trigger: f32,
        },

        buttons: packed struct(u15) {
            a: bool,
            b: bool,
            x: bool,
            y: bool,
            left_bumper: bool,
            right_bumper: bool,
            back: bool,
            start: bool,
            guide: bool,
            left_thumb: bool,
            right_thumb: bool,
            dpad_up: bool,
            dpad_right: bool,
            dpad_down: bool,
            dpad_left: bool,
        },
    };

    pub fn getName(self: @This()) ?[*:0]const u8 {
        return c.glfwGetGamepadName(@intFromEnum(self));
    }

    pub fn getState(self: @This()) ?State {
        var state: c.GLFWgamepadstate = undefined;
        return if (c.glfwGetGamepadState(@intFromEnum(self), &state) != c.GLFW_TRUE) null else State{
            .axis = .{
                .left_x = state.axes[c.GLFW_GAMEPAD_AXIS_LEFT_X],
                .left_y = state.axes[c.GLFW_GAMEPAD_AXIS_LEFT_Y],
                .right_x = state.axes[c.GLFW_GAMEPAD_AXIS_RIGHT_X],
                .right_y = state.axes[c.GLFW_GAMEPAD_AXIS_RIGHT_Y],
                .left_trigger = state.axes[c.GLFW_GAMEPAD_AXIS_LEFT_TRIGGER],
                .right_trigger = state.axes[c.GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER],
            },
            .buttons = .{
                .a = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_A)] == c.GLFW_PRESS,
                .b = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_B)] == c.GLFW_PRESS,
                .x = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_X)] == c.GLFW_PRESS,
                .y = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_Y)] == c.GLFW_PRESS,
                .left_bumper = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_LEFT_BUMPER)] == c.GLFW_PRESS,
                .right_bumper = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER)] == c.GLFW_PRESS,
                .back = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_BACK)] == c.GLFW_PRESS,
                .start = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_START)] == c.GLFW_PRESS,
                .guide = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_GUIDE)] == c.GLFW_PRESS,
                .left_thumb = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_LEFT_THUMB)] == c.GLFW_PRESS,
                .right_thumb = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_RIGHT_THUMB)] == c.GLFW_PRESS,
                .dpad_up = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_DPAD_UP)] == c.GLFW_PRESS,
                .dpad_right = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_DPAD_RIGHT)] == c.GLFW_PRESS,
                .dpad_down = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_DPAD_DOWN)] == c.GLFW_PRESS,
                .dpad_left = state.buttons[@intCast(c.GLFW_GAMEPAD_BUTTON_DPAD_LEFT)] == c.GLFW_PRESS,
            },
        };
    }

    pub fn updateMappings(str: [*:0]const u8) !void {
        if (c.glfwUpdateGamepadMappings(str) != c.GLFW_TRUE) return error.UpdateGamepadMappings;
    }
};

pub const clipboard = struct {
    pub fn set(window: *root.Window, str: [*:0]const u8) !void {
        c.glfwSetClipboardString(window.toC(), str);
        try err.check();
    }

    pub fn get(window: *root.Window) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetClipboardString(window.toC()));
    }
};

pub const Key = enum(c_int) {
    space = c.GLFW_KEY_SPACE,
    apostrophe = c.GLFW_KEY_APOSTROPHE,
    comma = c.GLFW_KEY_COMMA,
    minus = c.GLFW_KEY_MINUS,
    period = c.GLFW_KEY_PERIOD,
    slash = c.GLFW_KEY_SLASH,
    @"0" = c.GLFW_KEY_0,
    @"1" = c.GLFW_KEY_1,
    @"2" = c.GLFW_KEY_2,
    @"3" = c.GLFW_KEY_3,
    @"4" = c.GLFW_KEY_4,
    @"5" = c.GLFW_KEY_5,
    @"6" = c.GLFW_KEY_6,
    @"7" = c.GLFW_KEY_7,
    @"8" = c.GLFW_KEY_8,
    @"9" = c.GLFW_KEY_9,
    semicolon = c.GLFW_KEY_SEMICOLON,
    equal = c.GLFW_KEY_EQUAL,
    a = c.GLFW_KEY_A,
    b = c.GLFW_KEY_B,
    c = c.GLFW_KEY_C,
    d = c.GLFW_KEY_D,
    e = c.GLFW_KEY_E,
    f = c.GLFW_KEY_F,
    g = c.GLFW_KEY_G,
    h = c.GLFW_KEY_H,
    i = c.GLFW_KEY_I,
    j = c.GLFW_KEY_J,
    k = c.GLFW_KEY_K,
    l = c.GLFW_KEY_L,
    m = c.GLFW_KEY_M,
    n = c.GLFW_KEY_N,
    o = c.GLFW_KEY_O,
    p = c.GLFW_KEY_P,
    q = c.GLFW_KEY_Q,
    r = c.GLFW_KEY_R,
    s = c.GLFW_KEY_S,
    t = c.GLFW_KEY_T,
    u = c.GLFW_KEY_U,
    v = c.GLFW_KEY_V,
    w = c.GLFW_KEY_W,
    x = c.GLFW_KEY_X,
    y = c.GLFW_KEY_Y,
    z = c.GLFW_KEY_Z,
    left_bracket = c.GLFW_KEY_LEFT_BRACKET,
    backslash = c.GLFW_KEY_BACKSLASH,
    right_bracket = c.GLFW_KEY_RIGHT_BRACKET,
    grave_accent = c.GLFW_KEY_GRAVE_ACCENT,
    world_1 = c.GLFW_KEY_WORLD_1,
    world_2 = c.GLFW_KEY_WORLD_2,

    escape = c.GLFW_KEY_ESCAPE,
    enter = c.GLFW_KEY_ENTER,
    tab = c.GLFW_KEY_TAB,
    backspace = c.GLFW_KEY_BACKSPACE,
    insert = c.GLFW_KEY_INSERT,
    delete = c.GLFW_KEY_DELETE,
    right = c.GLFW_KEY_RIGHT,
    left = c.GLFW_KEY_LEFT,
    down = c.GLFW_KEY_DOWN,
    up = c.GLFW_KEY_UP,
    page_up = c.GLFW_KEY_PAGE_UP,
    page_down = c.GLFW_KEY_PAGE_DOWN,
    home = c.GLFW_KEY_HOME,
    end = c.GLFW_KEY_END,
    caps_lock = c.GLFW_KEY_CAPS_LOCK,
    scroll_lock = c.GLFW_KEY_SCROLL_LOCK,
    num_lock = c.GLFW_KEY_NUM_LOCK,
    print_screen = c.GLFW_KEY_PRINT_SCREEN,
    pause = c.GLFW_KEY_PAUSE,
    f1 = c.GLFW_KEY_F1,
    f2 = c.GLFW_KEY_F2,
    f3 = c.GLFW_KEY_F3,
    f4 = c.GLFW_KEY_F4,
    f5 = c.GLFW_KEY_F5,
    f6 = c.GLFW_KEY_F6,
    f7 = c.GLFW_KEY_F7,
    f8 = c.GLFW_KEY_F8,
    f9 = c.GLFW_KEY_F9,
    f10 = c.GLFW_KEY_F10,
    f11 = c.GLFW_KEY_F11,
    f12 = c.GLFW_KEY_F12,
    f13 = c.GLFW_KEY_F13,
    f14 = c.GLFW_KEY_F14,
    f15 = c.GLFW_KEY_F15,
    f16 = c.GLFW_KEY_F16,
    f17 = c.GLFW_KEY_F17,
    f18 = c.GLFW_KEY_F18,
    f19 = c.GLFW_KEY_F19,
    f20 = c.GLFW_KEY_F20,
    f21 = c.GLFW_KEY_F21,
    f22 = c.GLFW_KEY_F22,
    f23 = c.GLFW_KEY_F23,
    f24 = c.GLFW_KEY_F24,
    f25 = c.GLFW_KEY_F25,
    kp_0 = c.GLFW_KEY_KP_0,
    kp_1 = c.GLFW_KEY_KP_1,
    kp_2 = c.GLFW_KEY_KP_2,
    kp_3 = c.GLFW_KEY_KP_3,
    kp_4 = c.GLFW_KEY_KP_4,
    kp_5 = c.GLFW_KEY_KP_5,
    kp_6 = c.GLFW_KEY_KP_6,
    kp_7 = c.GLFW_KEY_KP_7,
    kp_8 = c.GLFW_KEY_KP_8,
    kp_9 = c.GLFW_KEY_KP_9,
    kp_decimal = c.GLFW_KEY_KP_DECIMAL,
    kp_divide = c.GLFW_KEY_KP_DIVIDE,
    kp_multiply = c.GLFW_KEY_KP_MULTIPLY,
    kp_subtract = c.GLFW_KEY_KP_SUBTRACT,
    kp_add = c.GLFW_KEY_KP_ADD,
    kp_enter = c.GLFW_KEY_KP_ENTER,
    kp_equal = c.GLFW_KEY_KP_EQUAL,
    left_shift = c.GLFW_KEY_LEFT_SHIFT,
    left_control = c.GLFW_KEY_LEFT_CONTROL,
    left_alt = c.GLFW_KEY_LEFT_ALT,
    left_super = c.GLFW_KEY_LEFT_SUPER,
    right_shift = c.GLFW_KEY_RIGHT_SHIFT,
    right_control = c.GLFW_KEY_RIGHT_CONTROL,
    right_alt = c.GLFW_KEY_RIGHT_ALT,
    right_super = c.GLFW_KEY_RIGHT_SUPER,
    menu = c.GLFW_KEY_MENU,

    pub const State = packed struct(u3) {
        release: bool,
        press: bool,
        repeat: bool,
    };

    /// Same as 'glfwGetKey'
    pub fn get(self: @This(), window: *root.Window) bool {
        return c.glfwGetKey(window.toC(), @intFromEnum(self)) == c.GLFW_PRESS;
    }

    /// Same as 'glfwGetKeyScancode'
    pub fn toScancode(self: @This()) usize {
        return @intCast(c.glfwGetKeyScancode(@intFromEnum(self)));
    }

    /// Same as 'glfwGetKeyName'
    pub fn toStr(self: @This()) ?[*:0]const u8 {
        return @ptrCast(c.glfwGetKeyName(@intFromEnum(self), @intCast(self.toScancode())) orelse return null);
    }
};
