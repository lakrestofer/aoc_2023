const std = @import("std");
const day1 = @import("day1");

// modules
const io = std.io;
const process = std.process;
const fs = std.fs;

// types
const File = fs.File;

pub fn main() !void {
    var args = process.ArgIteratorPosix.init(); // we need access the number of args
    const stdout = std.io.getStdOut().writer();

    if (args.count == 1 or args.count > 2) {
        try stdout.print("usage: ./zimacs ./program.zi\n", .{});
        std.process.exit(1);
    }

    // throw away first argument, since that is simply the name of the program
    _ = args.next().?;
    // get path to input file, cannot be empty (since we know we have 2 arguments)
    const input_path: [:0]const u8 = args.next().?;

    // we create an allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    try stdout.print("input file: {s}\n", .{input_path});

    // open file handle
    const cwd = fs.cwd();
    const input_file: File = try cwd.openFile(input_path, File.OpenFlags{});
    defer input_file.close();

    const file_content: []u8 = try input_file.readToEndAlloc(allocator, 640000);

    const buffer_reader = io.fixedBufferStream(file_content);

    day1
}
