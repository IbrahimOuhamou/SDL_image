بسم الله الرحمن الرحيم
# SDL_image but with the zig build system

This is a port of [SDL_image](https://github.com/libsdl-org/SDL_image) to the zig build system, to use it with the zig package manager.

This is ***not*** a wrapper.

## Usage

Requires zig version `0.14.0`, higher versions not tested.

Fetch it with:
```bash
zig fetch --save git+https://github.com/IbrahimOuhamou/SDL_image.git
```

And link it in your `build.zig`:
```zig
{
    // SDL_image Dependency
    const sdl_image_dep = b.dependency("sdl_image", .{
        .target = target,
        .optimize = optimize,
    });
    const sdl_image_lib = sdl_image_dep.artifact("SDL_image");

    exe_mod.linkLibrary(sdl_image_lib);
}
```

> [!NOTE]
> This was only tested on NixOS (wayland) with 0.14.0 for my personal use

