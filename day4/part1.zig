const std = @import("std");

pub fn main() !void {
    const content = try read_file("day4/input.txt");
    const n_cols = [_]u8{ 10, 25 };
    var numbers: [n_cols[0]]u8 = undefined;
    var pointer: usize = 0;
    var iterator = std.mem.splitAny(u8, content, " \n");
    var n_cards: u8 = 0;
    var total: u32 = 0;
    while (iterator.next()) |element| {
        const value = std.fmt.parseInt(u8, element, 10) catch continue;
        if (pointer < n_cols[0]) {
            numbers[pointer] = value;
        } else if (std.mem.indexOf(u8, &numbers, &[_]u8{value})) |cvalue| {
            _ = cvalue;
            n_cards += 1;
        }
        if (pointer == n_cols[0] + n_cols[1] - 1) {
            if (n_cards != 0) {
                total += std.math.pow(u32, 2, n_cards - 1);
            }
            n_cards = 0;
            pointer = 0;
            continue;
        }
        pointer += 1;
    }
    std.debug.print("{d}\n", .{total});
}
pub fn read_file(input_file: []const u8) ![]const u8 {
    const alloc = std.heap.page_allocator;
    const file = try std.fs.cwd().openFile(input_file, .{});
    return try file.reader().readAllAlloc(alloc, std.math.maxInt(usize));
}
