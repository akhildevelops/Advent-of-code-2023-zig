const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("day2/input.txt", .{});
    const content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));

    const colors = [_][]const u8{ "red", "green", "blue" };
    const constraints = std.ComptimeStringMap(u32, .{ .{ colors[0], 12 }, .{ colors[1], 13 }, .{ colors[2], 14 } });
    var game_sum: u32 = 0;
    var game_n: u32 = 0;
    var jump = false;
    for (0..content.len) |index| {
        if (jump and content[index] != '\n') {
            continue;
        }
        if (content[index] == '\n') {
            jump = false;
            game_n = 0;
        }
        if (std.mem.startsWith(u8, content[index..], ":")) {
            game_n = try get_number(content, index - 1);
            game_sum += game_n;
        }
        inline for (colors) |color| {
            if (std.mem.startsWith(u8, content[index..], color)) {
                const color_val = try get_number(content, index - 2);
                if (color_val > constraints.get(color).?) {
                    game_sum -= game_n;
                    jump = true;
                }
            }
        }
    }
    std.debug.print("{d}\n", .{game_sum});
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
