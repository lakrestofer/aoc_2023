const std = @import("std");

const io = std.io;

pub fn solve(input: []u8) !void {
    const stdin = io.getStdErr().writer();
    try stdin.print("length of input in bytes: {d}\n", .{input.len});
}
