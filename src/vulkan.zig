const c = @import("c");
const err = @import("err.zig");
const root = @import("root.zig");

const Instance = *opaque {};
const PhysicalDevice = *opaque {};
const Surface = *opaque {};

pub extern fn glfwCreateWindowSurface(instance: Instance, user_data: *anyopaque, allocator: ?*const anyopaque, surface: *Surface) c_int;

pub fn initVulkanLoader(loader: anytype) void {
    c.glfwInitVulkanLoader(loader);
}

pub fn supported() !bool {
    const result = c.glfwVulkanSupported() == c.GLFW_TRUE;
    try err.check();
    return result;
}

pub fn getRequiredInstanceExtensions() [][*:0]const u8 {
    var count: u32 = undefined;
    const extensions = c.glfwGetRequiredInstanceExtensions(&count);
    return @ptrCast(extensions[0..@intCast(count)]);
}

pub fn getInstanceProcAddress(instance: Instance, proc_name: [*:0]const u8) *const fn () void {
    return c.glfwGetInstanceProcAddress(@ptrCast(instance), @ptrCast(proc_name));
}

pub fn getPhysicalDevicePresentationSupport(instance: Instance, device: PhysicalDevice, queue_family: u32) bool {
    return c.glfwGetPhysicalDevicePresentationSupport(@ptrCast(instance), @ptrCast(device), queue_family) == c.GLFW_TRUE;
}

/// Same as 'glfwCreateWindowSurface'
pub fn initSurface(instance: Instance, window: *root.Window, allocator: ?*const anyopaque) ?Surface {
    var surface: Surface = undefined;
    if (glfwCreateWindowSurface(@ptrCast(instance), window.toC(), @ptrCast(allocator), @ptrCast(&surface)) == 0) return null;
    return surface;
}
