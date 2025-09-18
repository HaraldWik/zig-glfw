const std = @import("std");
const build_options = @import("build_options");
const root = @import("root.zig");
const c = @import("c");
const err = @import("err.zig");

pub const win32 = if (build_options.win32) struct {
    pub const Window = std.os.windows.HWND;

    pub fn getMonitor(monitor: root.Monitor) ![*:0]const u8 {
        const m = c.glfwGetWin32Monitor(monitor.toC());
        try err.check();
        return @ptrCast(m);
    }

    pub fn getAdapter(monitor: root.Monitor) ![*:0]const u8 {
        const adapter = c.glfwGetWin32Adapter(monitor.toC());
        try err.check();
        return @ptrCast(adapter);
    }

    pub fn getWindow(window: *root.Window) !Window {
        const hwnd = c.glfwGetWin32Window(window.toC());
        try err.check();
        return @ptrCast(hwnd);
    }
} else @compileError("Add '.win32 = true' in dependency to expose win32");

pub const cocoa = if (build_options.cocoa) struct {
    pub const Monitor = enum(u32) { _ };
    pub const Window = *opaque {};

    pub fn getMonitor(monitor: root.Monitor) !Monitor {
        const id = c.glfwGetCocoaMonitor(monitor.toC());
        try err.check();
        return @enumFromInt(id);
    }

    pub fn getWindow(window: *root.Window) !Window {
        const id = c.glfwGetCocoaWindow(window.toC());
        try err.check();
        return @ptrCast(id);
    }
} else @compileError("Add '.cocoa = true' in dependency to expose cocoa");

pub const x11 = if (build_options.x11) struct {
    pub const Monitor = *opaque {};
    pub const Winodw = *opaque {};
    pub const Display = *opaque {};
    pub const Adapter = *opaque {};

    pub fn getMonitor(monitor: root.Monitor) !Monitor {
        const m = c.glfwGetX11Adapter(monitor.toC());
        try err.check();
        return @ptrCast(m);
    }

    pub fn getWindow(window: *root.Window) !Winodw {
        const w = c.glfwGetX11Window(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub fn getDisplay() !Display {
        const display = c.glfwGetX11Display();
        try err.check();
        return @ptrCast(display);
    }

    pub fn getAdapter(monitor: root.Monitor) !Adapter {
        const adapter = c.glfwGetX11Adapter(monitor.toC());
        try err.check();
        return @ptrCast(adapter);
    }

    pub fn getSelectionStr() ?[*:0]const u8 {
        return @ptrCast(c.glfwGetX11SelectionString());
    }

    pub fn setSelectionStr(str: [*:0]const u8) !void {
        c.glfwSetX11SelectionString(@ptrCast(str));
        try err.check();
    }
} else @compileError("Add '.x11 = true' in dependency to expose x11");

pub const wayland = if (build_options.wayland) struct {
    pub const Display = *opaque {};
    pub const Monitor = *opaque {};
    pub const Window = *opaque {};

    pub fn getMonitor(monitor: root.Monitor) !Monitor {
        const m = c.glfwGetWaylandMonitor(monitor.toC());
        try err.check();
        return @ptrCast(m);
    }

    pub fn getWindow(window: *root.Window) !Window {
        const w = c.glfwGetWaylandWindow(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub fn getDisplay() !Display {
        const display = c.glfwGetWaylandDisplay();
        try err.check();
        return @ptrCast(display);
    }
} else @compileError("Add '.wayland = true' in dependency to expose wayland");

pub const wgl = if (build_options.wgl) struct {
    pub const Context = std.os.windows.HGLRC;

    pub fn getContext(window: *root.Window) !Context {
        const ctx = c.glfwGetWGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
} else @compileError("Add '.wgl = true' in dependency to expose web module");

pub const nsgl = if (build_options.nsgl) struct {
    pub const Context = if (build_options.cocoa) cocoa.Window else *opaque {};

    pub fn getContext(window: *root.Window) !Context {
        const ctx = c.glfwGetNSGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
} else @compileError("Add '.nsgl = true' in dependency to expose nsgl");

pub const glx = if (build_options.glx) struct {
    pub const Context = *opaque {};
    pub const Window = *opaque {};

    pub fn getContext(window: *root.Window) !Context {
        const ctx = c.glfwGetGLXContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }

    pub fn getWindow(window: *root.Window) !Window {
        const w = c.glfwGetGLXWindow(window.toC());
        try err.check();
        return @ptrCast(w);
    }
} else @compileError("Add '.glx = true' in dependency to expose glx");

pub const egl = if (build_options.egl) struct {
    pub const Context = *opaque {};
    pub const Surface = *opaque {};
    pub const Display = *opaque {};

    pub fn getContext(window: *root.Window) !Context {
        const ctx = c.glfwGetEGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
    pub fn getSurface(window: *root.Window) !Surface {
        const w = c.glfwGetEGLSurface(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub fn getDisplay() !Display {
        const display = c.glfwGetEGLDisplay();
        try err.check();
        return @ptrCast(display);
    }
} else @compileError("Add '.egl = true' in dependency to expose egl");

pub const osmesa = if (build_options.osmesa) struct {
    pub const Context = *opaque {};
    pub const DepthBuffer = struct { size: root.Size(usize), bytes_per_val: usize, buffer: [*]u8 };
    pub const ColorBuffer = struct { size: root.Size(usize), format: usize, buffer: [*]u8 };

    pub fn getColorBuffer(window: *root.Window) !DepthBuffer {
        var width: c_int = undefined;
        var height: c_int = undefined;
        var format: c_int = undefined;
        var buffer: *anyopaque = undefined;
        if (c.glfwGetOSMesaColorBuffer(window.toC(), &width, &height, &format, &buffer) != c.GLFW_TRUE) return error.GetColorBuffer;
        return .{
            .size = .{ .width = @intCast(width), .height = @intCast(height) },
            .format = @intCast(format),
            .buffer = @ptrCast(buffer),
        };
    }

    pub fn getDepthBuffer(window: *root.Window) !DepthBuffer {
        var width: c_int = undefined;
        var height: c_int = undefined;
        var bytes_per_val: c_int = undefined;
        var buffer: *anyopaque = undefined;
        if (c.glfwGetOSMesaDepthBuffer(window.toC(), &width, &height, &bytes_per_val, &buffer) != c.GLFW_TRUE) return error.GetDepthBuffer;
        return .{
            .size = .{ .width = @intCast(width), .height = @intCast(height) },
            .bytes_per_val = @intCast(bytes_per_val),
            .buffer = @ptrCast(buffer),
        };
    }

    pub fn getContext(window: *root.Window) !Context {
        const ctx = c.glfwGetOSMesaContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
} else @compileError("Add '.osmesa = true' in dependency to expose osmesa");
