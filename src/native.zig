const std = @import("std");
const build_options = @import("build_options");
const c = @import("c");
const root = @import("root.zig");
const err = @import("err.zig");

pub const win32 = if (build_options.win32) struct {
    pub inline fn getMonitor(monitor: root.Monitor) ![*:0]const u8 {
        const m = c.glfwGetWin32Monitor(monitor);
        try err.check();
        return m;
    }

    pub inline fn getAdapter(monitor: root.Monitor) ![*:0]const u8 {
        const adapter = c.glfwGetWin32Adapter(monitor.toC());
        try err.check();
        return adapter;
    }

    pub inline fn getWindow(window: root.Window) !std.os.windows.HWND {
        const hwnd = c.glfwGetWin32Window(window.toC());
        try err.check();
        return @ptrCast(hwnd);
    }
} else struct {};

pub const cocoa = if (build_options.cocoa) struct {
    pub const NSWindow = *opaque {};

    pub inline fn getMonitor(monitor: root.Monitor) !u32 {
        const id = c.glfwGetCocoaMonitor(monitor.toC());
        try err.check();
        return id;
    }

    pub inline fn getWindow(window: root.Window) !NSWindow {
        const id = c.glfwGetCocoaWindow(window.toC());
        try err.check();
        return @ptrCast(id);
    }

    pub inline fn getView(window: root.Window) !NSWindow {
        const id = c.glfwGetCocoaView(window.toC());
        try err.check();
        return @ptrCast(id);
    }
} else struct {};

pub const x11 = if (build_options.x11) struct {
    pub const Display = *opaque {};

    pub inline fn getMonitor(monitor: root.Monitor) !*anyopaque {
        const m = c.glfwGetX11Adapter(monitor.toC());
        try err.check();
        return @ptrCast(m);
    }

    pub inline fn getAdapter(monitor: root.Monitor) !*anyopaque {
        const adapter = c.glfwGetX11Adapter(monitor.toC());
        try err.check();
        return @ptrCast(adapter);
    }

    pub inline fn getWindow(window: root.Window) !*anyopaque {
        const w = c.glfwGetX11Window(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub inline fn getDisplay() !Display {
        const display = c.glfwGetX11Display();
        try err.check();
        return @ptrCast(display);
    }

    pub inline fn getSelectionStr() [*:0]const u8 {
        return c.glfwGetX11SelectionString();
    }

    pub inline fn setSelectionStr(str: [*:0]const u8) !void {
        c.glfwSetX11SelectionString(str);
        try err.check();
    }
} else struct {};

pub const wayland = if (build_options.wayland) struct {
    pub const Display = *opaque {};

    pub inline fn getMonitor(monitor: root.Monitor) !*anyopaque {
        const m = c.glfwGetWaylandMonitor(monitor.toC());
        try err.check();
        return @ptrCast(m);
    }

    pub inline fn getWindow(window: root.Window) !*anyopaque {
        const w = c.glfwGetWaylandWindow(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub inline fn getDisplay() !Display {
        const display = c.glfwGetWaylandDisplay();
        try err.check();
        return @ptrCast(display);
    }
} else struct {};

pub const wgl = if (build_options.wgl) struct {} else struct {
    pub const HGLRC = *opaque {};

    pub inline fn getContext(window: root.Window) !HGLRC {
        const ctx = c.glfwGetWGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
};

pub const nsgl = if (build_options.nsgl) struct {
    pub const NSWindow = if (build_options.cocoa) cocoa.NSWindow else *opaque {};

    pub inline fn getContext(window: root.Window) NSWindow {
        const ctx = c.glfwGetNSGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
} else struct {};

pub const glx = if (build_options.glx) struct {
    pub const Context = *opaque {};

    pub inline fn getContext(window: root.Window) !Context {
        const ctx = c.glfwGetGLXContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }

    pub inline fn getWindow(window: root.Window) !*anyopaque {
        const w = c.glfwGetGLXWindow(window.toC());
        try err.check();
        return @ptrCast(w);
    }
} else struct {};

pub const egl = if (build_options.egl) struct {
    pub const Context = *opaque {};
    pub const Surface = *opaque {};
    pub const Display = *opaque {};

    pub inline fn getContext(window: root.Window) !Context {
        const ctx = c.glfwGetEGLContext(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
    pub inline fn getSurface(window: root.Window) !Surface {
        const w = c.glfwGetEGLSurface(window.toC());
        try err.check();
        return @ptrCast(w);
    }

    pub inline fn getDisplay() !Display {
        const display = c.glfwGetEGLDisplay();
        try err.check();
        return @ptrCast(display);
    }
} else struct {};

pub const osmesa = if (build_options.osmesa) struct {
    pub const Context = *opaque {};

    // TODO: Fix
    pub const getColorBuffer = c.glfwGetOSMesaColorBuffer;

    // TODO: Fix
    pub const getDepthBuffer = c.glfwGetOSMesaDepthBuffer;

    pub inline fn getContext(window: root.Window) !Context {
        const ctx = c.glfwGetOSMesaColorBuffer(window.toC());
        try err.check();
        return @ptrCast(ctx);
    }
} else struct {};
