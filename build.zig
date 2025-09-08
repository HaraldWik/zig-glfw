const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c = b.addTranslateC(.{
        .root_source_file = b.addWriteFiles().add("c.h",
            \\#include <GLFW/glfw3native.h>
            \\#include <GLFW/glfw3.h>
        ),
        .target = target,
        .optimize = optimize,
    }).createModule();
    c.linkSystemLibrary("GLFW", .{});

    const mod = b.addModule("zig_glfw", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "c", .module = c },
        },
    });
    mod.linkSystemLibrary("GLFW", .{});
    mod.linkSystemLibrary("GL", .{});

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
