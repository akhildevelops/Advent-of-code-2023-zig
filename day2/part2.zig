const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("day2/input.txt", .{});
    const content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    const colors = [_][]const u8{ "red", "blue", "green" };
    var min_colors = [_]u32{ 1, 1, 1 };
    var power: u32 = 0;
    for (0..content.len) |index| {
        if (content[index] == '\n') {
            power += (min_colors[0] * min_colors[1] * min_colors[2]);
            min_colors = .{ 1, 1, 1 };
        }
        inline for (colors) |color| {
            if (std.mem.startsWith(u8, content[index..], color)) {
                const color_val = try get_number(content, index - 2);
                inline for (0..3) |i| {
                    if (std.mem.eql(u8, color, colors[i])) {
                        min_colors[i] = @max(min_colors[i], color_val);
                    }
                }
            }
        }
    }
    std.debug.print("{d}\n", .{power});
}

fn get_number(content: []const u8, index: usize) !u32 {
    var start = index;
    const end = index;
    while (true) : (start -= 1) {
        if ('0' > content[start] or content[start] > '9') {
            break;
        }
    }
    // std.debug.print("{s}:{d}-{d}\n", .{ content[start + 1 .. end + 1], content[start], content[end] });
    return try std.fmt.parseInt(u32, content[start + 1 .. end + 1], 10);
}
