const std = @import("std");

// modules
const io = std.io;
const process = std.process;
const fs = std.fs;
const fmt = std.fmt;

// types
const File = fs.File;

pub fn main() !void {
    var args = process.ArgIteratorPosix.init(); // we need access the number of args
    const stdout = std.io.getStdOut().writer();

    if (args.count < 3 or args.count > 3) {
        try stdout.print("usage: ./aoc_2023 day ./input\n", .{});
        std.process.exit(1);
    }

    // throw away first argument, since that is simply the name of the program
    _ = args.next().?;
    // get path to input file, cannot be empty (since we know we have 2 arguments)
    const day_arg: [:0]const u8 = args.next().?;
    const day: i32 = try fmt.charToDigit(day_arg[0], 10);
    const input_path: [:0]const u8 = args.next().?;

    try stdout.print("day: {d}, file: {s}\n", .{ day, input_path });

    // we create an allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // open file handle
    const cwd = fs.cwd();
    const input_file: File = try cwd.openFile(input_path, File.OpenFlags{});
    defer input_file.close();

    const file_content: []u8 = try input_file.readToEndAlloc(allocator, 640000);
    defer allocator.free(file_content);

    switch (day) {
        1 => try @import("./day1.zig").solve(file_content),
        2 => try @import("./day2.zig").solve(file_content),
        else => |d| try stdout.print("no solution for day {d} has been implemented yet\n", .{d}),
    }
}
