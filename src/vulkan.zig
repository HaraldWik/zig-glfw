const c = @import("c");
const err = @import("err.zig");
const root = @import("root.zig");

const Instance = *opaque {};
const PhysicalDevice = *opaque {};
const Surface = *opaque {};

pub inline fn initVulkanLoader(loader: anytype) void {
    c.glfwInitVulkanLoader(loader);
}

pub inline fn vulkanSupported() !bool {
    const result = c.glfwVulkanSupported() == c.GLFW_TRUE;
    try err.check();
    return result;
}

pub inline fn getRequiredInstanceExtensions() [][*:0]const u8 {
    var count: u32 = undefined;
    const extensions = c.glfwGetRequiredInstanceExtensions(&count);
    return @ptrCast(extensions[0..@intCast(count)]);
}

pub inline fn getInstanceProcAddress(instance: Instance, proc_name: [*:0]const u8) *const fn () void {
    return c.glfwGetInstanceProcAddress(@ptrCast(instance), @ptrCast(proc_name));
}

pub inline fn getPhysicalDevicePresentationSupport(instance: Instance, device: PhysicalDevice, queue_family: u32) bool {
    return c.glfwGetPhysicalDevicePresentationSupport(@ptrCast(instance), @ptrCast(device), queue_family) == c.GLFW_TRUE;
}

/// Same as 'glfwCreateWindowSurface'
pub inline fn initSurface(instance: Instance, window: root.Window, allocator: *const anyopaque) Surface {
    var surface: Surface = undefined;
    if (c.glfwCreateWindowSurface(@ptrCast(instance), window.toC(), @ptrCast(allocator), @ptrCast(&surface)) != 0) return error.CreateSurface;
    return surface;
}
