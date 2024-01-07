const std = @import("std");
const io = std.io;
const mem = std.mem;
const fmt = std.fmt;
const heap = std.heap;

const Allocator = std.mem.Allocator;

// the number of red blue and greed boxes seen in this set
const Set = struct {
    r: u32,
    b: u32,
    g: u32,
};

const Game = struct {
    id: u32,
    sets: std.ArrayList(Set),
    max_seen: Set,

    const Self = @This();
};

pub fn solve(input: []u8) !void {
    var buffer: [8192]u8 = undefined;
    var buffer_allocator = heap.FixedBufferAllocator.init(&buffer);

    const stdout = io.getStdOut().writer();

    var sum: u32 = 0;

    var lines = mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        if (parse_game(line, buffer_allocator.allocator())) |game| {
            if (game.max_seen.r <= 12 and game.max_seen.b <= 13 and game.max_seen.g <= 14) {
                sum += game.id;
            }
        } else |_| {}
        // reset all the allocations made by the parse_game function
        buffer_allocator.reset();
    }

    try stdout.print("answer part 1: {d}\n", .{sum});
}

fn parse_game(line: []const u8, allocator: Allocator) !Game {
    var game = Game{ .id = undefined, .sets = std.ArrayList(Set).init(allocator), .max_seen = mem.zeroes(Set) };
    const stdout = io.getStdOut().writer();

    // parse id
    var game_id_sets = mem.splitScalar(u8, line, ':');
    // game
    const game_id = game_id_sets.first();
    // Game nnnn
    const id_slice = game_id[5..];
    try stdout.print("game id: {s}\n", .{id_slice});

    const id = try fmt.parseInt(u32, id_slice, 10);
    game.id = id;

    // // parse sets
    const sets_slice = game_id_sets.rest();
    var sets = mem.splitScalar(u8, sets_slice, ';');
    while (sets.next()) |set_slice| {
        if (parse_set(set_slice)) |set| {
            try game.sets.append(set);
        } else |_| {}
    } else |_| {}

    return game;
}

fn parse_set(set_slice: []const u8) !Set {
    // n color
    var count_color = mem.splitScalar(u8, set_slice, ' ');
    const count_slice = count_color.first();
    const count = try fmt.parseInt(count_slice);

    const color_slice = count_color.rest();


    switch (color_slice[0]) {
        'r' => 
    }
}
