const std = @import("std");
pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("day1/input.txt", .{});

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_content);

    var digit: [2]u8 = .{ '-', '-' };

    var sum: u32 = 0;

    for (file_content) |each| {
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
