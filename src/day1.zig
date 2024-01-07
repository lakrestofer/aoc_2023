const std = @import("std");

const io = std.io;
const fmt = std.fmt;
const mem = std.mem;

const line_buffer_size = 1048;

pub fn solve(input: []u8) !void {
    const stdout = io.getStdOut().writer();

    var sum: i32 = 0;

    var lines = mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (find_number_digits(line)) |number| {
            sum += number;
        } else |_| {}
    }

    try stdout.print("answer part 1: {d}\n", .{sum});
}

fn find_number_digits(line: []const u8) !i32 {
    var reader_stream = io.fixedBufferStream(line);
    var reader = reader_stream.reader();
    var first: i32 = undefined;
    // first we find the first number

    while (reader.readByte()) |byte| {
        if (fmt.charToDigit(byte, 10)) |digit| {
            first = digit;
            break; // break out and search for the second digit
        } else |_| {
            // ignore parse errors
        }
    } else |err| switch (err) {
        // any error that occurs while searching for the first number is an error
        else => |e| return e,
    }

    // then we find the last number. By default it is equal to the first number (e.g oienrat2oaeirnts -> 22)
    var second: i32 = first;
    while (reader.readByte()) |byte| {
        if (fmt.charToDigit(byte, 10)) |digit| {
            second = digit;
        } else |_| {
            // ignore the error
        }
    } else |err| switch (err) {
        // any error that occurs while searching for the first number is an error
        error.EndOfStream => {}, // ignore end of
        else => |e| return e,
    }

    return first * 10 + second;
}
