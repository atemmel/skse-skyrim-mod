const std = @import("std");
const Target = std.Target;
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *std.build.Builder) void {
    const os = Target.Os.Tag.defaultVersionRange(.windows, .x86_64);
    const target = CrossTarget.fromTarget(.{
        .cpu = Target.Cpu.Model.toCpu(Target.Cpu.Model.generic(.x86_64), .x86_64),
        .os = os,
        .abi = Target.Abi.default(.x86_64, os),
        .ofmt = Target.ObjectFormat.c,
    });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addSharedLibrary("skse-skyrim-mod", "src/main.cpp", b.version(0, 0, 1));
    lib.addCSourceFiles(&.{
        "vendor/common/IDebugLog.cpp",
        "vendor/common/IFileStream.cpp",
        "vendor/common/ITypes.cpp",
    }, &.{});
    lib.linkLibCpp();
    lib.addIncludePath("vendor");
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();
}
