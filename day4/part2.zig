const std = @import("std");

pub fn main() !void {
    const content = try read_file("day4/input.txt");
    const n_cols = [_]u8{ 10, 25 };
    var n_cards = [_]u32{0} ** 223;
    var card_pointer: usize = 0;
    var numbers: [n_cols[0]]u8 = undefined;
    var pointer: usize = 0;
    var n_wins: u8 = 0;
    var iterator = std.mem.splitAny(u8, content, " \n");
    while (iterator.next()) |element| {
        const value = std.fmt.parseInt(u8, element, 10) catch continue;
        if (pointer < n_cols[0]) {
            numbers[pointer] = value;
        } else if (std.mem.indexOf(u8, &numbers, &[_]u8{value})) |cvalue| {
            _ = cvalue;
            n_wins += 1;
        }
        if (pointer == n_cols[0] + n_cols[1] - 1) {
            n_cards[card_pointer] += 1;
            for (0..n_cards[card_pointer]) |nth| {
                _ = nth;

                for (1..n_wins + 1) |card_n| {
                    n_cards[card_n + card_pointer] += 1;
                }
            }
            card_pointer += 1;
            pointer = 0;
            n_wins = 0;
            continue;
        }
        pointer += 1;
    }
    var i: u32 = 0;
    for (n_cards) |x| i += x; //https://www.reddit.com/r/Zig/comments/zdemxm/comment/iz3vzsv/?utm_source=share&utm_medium=web2x&context=3
    std.debug.print("{d}\n", .{i});
}
pub fn read_file(input_file: []const u8) ![]const u8 {
    const alloc = std.heap.page_allocator;
    const file = try std.fs.cwd().openFile(input_file, .{});
    return try file.reader().readAllAlloc(alloc, std.math.maxInt(usize));
}
