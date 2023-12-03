const std = @import("std");
pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("day1/input.txt", .{});

    var file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_content);

    var digit: [2]u8 = .{ '-', '-' };
    const nstr = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    const nstrmap = std.ComptimeStringMap(u8, .{ .{ nstr[0], '1' }, .{ nstr[1], '2' }, .{ nstr[2], '3' }, .{ nstr[3], '4' }, .{ nstr[4], '5' }, .{ nstr[5], '6' }, .{ nstr[6], '7' }, .{ nstr[7], '8' }, .{ nstr[8], '9' } });

    var sum: u32 = 0;

    for (0..file_content.len) |index| {
        var each = file_content[index];
        inline for (nstr) |nth| {
            if (std.mem.startsWith(u8, file_content[index..], nth)) {
                each = nstrmap.get(nth).?;
            }
        }
        if ('0' <= each and '9' >= each) {
            if (digit[0] == '-') {
                digit[0] = each - '0';
                continue;
            }
            digit[1] = each - '0';
        }
        if (each == '\n') {
            if (digit[1] == '-') {
                digit[1] = digit[0];
            }
            sum += digit[0] * 10 + digit[1];
            digit = .{ '-', '-' };
        }
    }
    std.debug.print("{d}\n", .{sum});
}
