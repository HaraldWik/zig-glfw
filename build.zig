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

    const glfw = b.dependency("glfw", .{});

    const glfw_lib = b.addLibrary(.{
        .name = "glfw",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
        .linkage = .static,
    });

    const files: []const ?[]const u8 = &.{
        "context.c",
        "init.c",
        "input.c",
        "monitor.c",
        "vulkan.c",
        "window.c",
        "osmesa_context.c",
    };
    for (files) |file| {
        if (file) |_| glfw_lib.addCSourceFile(.{ .file = glfw.path(b.fmt("src/{s}", .{file.?})) });
    }

    const mod = b.addModule("zig_glfw", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "c", .module = c },
        },
    });
    // mod.linkSystemLibrary("GLFW", .{});
    mod.linkLibrary(glfw_lib);

    const win32 = b.option(bool, "win32", "GLFW_EXPOSE_NATIVE_WIN32");
    const cocoa = b.option(bool, "cocoa", "GLFW_EXPOSE_NATIVE_COCOA");
    const x11 = b.option(bool, "x11", "GLFW_EXPOSE_NATIVE_X11");
    const wayland = b.option(bool, "wayland", "GLFW_EXPOSE_NATIVE_WAYLAND");
    const vulkan = b.option(bool, "vulkan", "VK_VERSION_1_0");
    const none = b.option(bool, "none", "GLFW_INCLUDE_NONE");
    const wgl = b.option(bool, "wgl", "GLFW_EXPOSE_NATIVE_WGL");
    const nsgl = b.option(bool, "nsgl", "GLFW_EXPOSE_NATIVE_NSGL");
    const glx = b.option(bool, "glx", "GLFW_EXPOSE_NATIVE_GLX");
    const egl = b.option(bool, "egl", "GLFW_EXPOSE_NATIVE_EGL");
    const osmesa = b.option(bool, "osmesa", "GLFW_EXPOSE_NATIVE_OSMESA");

    const options = b.addOptions();
    options.addOption(bool, "win32", win32 orelse false);
    options.addOption(bool, "cocoa", cocoa orelse false);
    options.addOption(bool, "x11", x11 orelse false);
    options.addOption(bool, "wayland", wayland orelse false);
    options.addOption(bool, "vulkan", vulkan orelse false);
    options.addOption(bool, "none", none orelse false);
    options.addOption(bool, "wgl", wgl orelse false);
    options.addOption(bool, "nsgl", nsgl orelse false);
    options.addOption(bool, "glx", glx orelse false);
    options.addOption(bool, "egl", glx orelse false);
    options.addOption(bool, "osmesa", osmesa orelse false);

    mod.addOptions("build_options", options);

    if (win32) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WIN32", if (def) "1" else "0");
    if (cocoa) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_COCOA", if (def) "1" else "0");
    if (x11) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_X11", if (def) "1" else "0");
    if (wayland) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WAYLAND", if (def) "1" else "0");
    if (vulkan) |def| mod.addCMacro("#define VK_VERSION_1_0", if (def) "1" else "0");
    if (none) |def| mod.addCMacro("#define GLFW_INCLUDE_NONE", if (def) "1" else "0");
    if (wgl) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WGL", if (def) "1" else "0");
    if (nsgl) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_WGL", if (def) "1" else "0");
    if (glx) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_GLX", if (def) "1" else "0");
    if (egl) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_EGL", if (def) "1" else "0");
    if (osmesa) |def| mod.addCMacro("#define GLFW_EXPOSE_NATIVE_OSMESA", if (def) "1" else "0");

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
