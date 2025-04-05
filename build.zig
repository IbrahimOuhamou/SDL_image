const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const preferred_link_mode = b.option(
        std.builtin.LinkMode,
        "preferred_link_mode",
        "Prefer building SDL as a statically or dynamically linked library (default: static)",
    ) orelse .static;

    var windows = false;
    var linux = false;
    var macos = false;
    switch (target.result.os.tag) {
        .windows => {
            windows = true;
        },
        .linux => {
            linux = true;
        },
        .macos => {
            macos = true;
        },
        else => {},
    }

    const sdl_image_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    sdl_image_mod.addCSourceFiles(.{
        .files = &[_][]const u8{
            "IMG_avif.c",
            "IMG_bmp.c",
            "IMG_gif.c",
            "IMG_jpg.c",
            "IMG_jxl.c",
            "IMG_lbm.c",
            "IMG_pcx.c",
            "IMG_png.c",
            "IMG_pnm.c",
            "IMG_qoi.c",
            "IMG_stb.c",
            "IMG_svg.c",
            "IMG_tga.c",
            "IMG_tif.c",
            "IMG_webp.c",
            "IMG_WIC.c",
            "IMG_xcf.c",
            "IMG_xpm.c",
            "IMG_xv.c",
            "IMG_xxx.c",
            "IMG.c",
        },
        .root = b.path("src/"),
        .flags = &.{},
    });
    sdl_image_mod.addIncludePath(b.path("include/"));
    
    sdl_image_mod.addCMacro("USE_STBIMAGE", "1");
    sdl_image_mod.addCMacro("LOAD_BMP", "1");
    sdl_image_mod.addCMacro("LOAD_GIF", "1");
    sdl_image_mod.addCMacro("LOAD_JPG", "1");
    sdl_image_mod.addCMacro("LOAD_PNG", "1");
    sdl_image_mod.addCMacro("LOAD_SVG", "1");
    sdl_image_mod.addCMacro("LOAD_TGA", "1");

    const sdl_image = b.addLibrary(.{
        .name = "SDL_image",
        .linkage = preferred_link_mode,
        .root_module = sdl_image_mod,
    });
    sdl_image.linkLibC();
    sdl_image.installHeadersDirectory(b.path("include/SDL3_image"), "SDL3_image", .{});


    {
        // SDL Dependency
        const sdl_dep = b.dependency("sdl", .{
            .target = target,
            .optimize = optimize,
            .preferred_link_mode = .static,
        });
        sdl_image_mod.linkLibrary(sdl_dep.artifact("SDL3"));
        // const sdl_test_lib = sdl_dep.artifact("SDL3_test");
    }
    const install_sdl_image_lib = b.addInstallArtifact(sdl_image, .{});

    const install_sdl_image_step = b.step("install_sdl_image", "Install SDL_image");
    install_sdl_image_step.dependOn(&install_sdl_image_lib.step);

    b.getInstallStep().dependOn(&install_sdl_image_lib.step);
}
