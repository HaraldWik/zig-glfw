const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c = b.addTranslateC(.{
        .root_source_file = b.addWriteFiles().add(
            "c.h",
            \\#include <GLFW/glfw3native.h>
            \\#include <GLFW/glfw3.h>
            ,
        ),
        .target = target,
        .optimize = optimize,
    }).createModule();

    const mod = b.addModule("zig_glfw", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "c", .module = c },
        },
    });
    mod.linkSystemLibrary("glfw", .{});

    const win32 = b.option(bool, "win32", "GLFW_EXPOSE_NATIVE_WIN32") orelse (target.result.os.tag == .windows);
    const cocoa = b.option(bool, "cocoa", "GLFW_EXPOSE_NATIVE_COCOA") orelse (target.result.os.tag == .macos);
    const x11 = b.option(bool, "x11", "GLFW_EXPOSE_NATIVE_X11") orelse (target.result.os.tag == .linux);
    const wayland = b.option(bool, "wayland", "GLFW_EXPOSE_NATIVE_WAYLAND") orelse (target.result.os.tag == .linux);

    const vulkan = b.option(bool, "vulkan", "VK_VERSION_1_0") orelse false;
    const none = b.option(bool, "none", "GLFW_INCLUDE_NONE") orelse false;
    const wgl = b.option(bool, "wgl", "GLFW_EXPOSE_NATIVE_WGL") orelse false;
    const nsgl = b.option(bool, "nsgl", "GLFW_EXPOSE_NATIVE_NSGL") orelse false;
    const glx = b.option(bool, "glx", "GLFW_EXPOSE_NATIVE_GLX") orelse false;
    const egl = b.option(bool, "egl", "GLFW_EXPOSE_NATIVE_EGL") orelse false;
    const osmesa = b.option(bool, "osmesa", "GLFW_EXPOSE_NATIVE_OSMESA") orelse false;

    const options = b.addOptions();
    options.addOption(bool, "win32", win32);
    options.addOption(bool, "cocoa", cocoa);
    options.addOption(bool, "x11", x11);
    options.addOption(bool, "wayland", wayland);

    options.addOption(bool, "vulkan", vulkan);
    options.addOption(bool, "none", none);
    options.addOption(bool, "wgl", wgl);
    options.addOption(bool, "nsgl", nsgl);
    options.addOption(bool, "glx", glx);
    options.addOption(bool, "egl", glx);
    options.addOption(bool, "osmesa", osmesa);

    mod.addOptions("build_options", options);

    if (win32) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WIN32", "1");
    if (cocoa) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_COCOA", "1");
    if (x11) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_X11", "1");
    if (wayland) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WAYLAND", "1");

    if (vulkan) mod.addCMacro("#define VK_VERSION_1_0", "1");
    if (none) mod.addCMacro("#define GLFW_INCLUDE_NONE", "1");
    if (wgl) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WGL", "1");
    if (nsgl) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WGL", "1");
    if (glx) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_GLX", "1");
    if (egl) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_EGL", "1");
    if (osmesa) mod.addCMacro("#define GLFW_EXPOSE_NATIVE_OSMESA", "1");
}
