const std = @import("std");
const Target = std.Target;
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
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

    const exe = b.addExecutable("skse-skyrim-mod", "src/main.cpp");
    exe.setTarget(target);
    exe.linkLibCpp();
    exe.linkLibC();
    exe.addIncludePath("vendor");
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
