const build_options = @import("build_options");
const c = @import("c");
const err = @import("err.zig");

pub const getProcAddress = c.glfwGetProcAddress;
