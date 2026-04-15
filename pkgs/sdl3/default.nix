{
  stdenv,
  pkgs,
  inputs,
  ...
}:
stdenv.mkDerivation {
  name = "sdl3";

  src = inputs.sdl3;

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    wayland-scanner
  ];

  # SDL3's CMake auto-detects video backends based on what's visible at
  # configure time. With only libX11 present, the Wayland backend was
  # partially enabled but missing its runtime deps, and Wayland_ShowCursor
  # crashed in wl_proxy_get_version during SDL_VideoInit. Give it the full
  # set for both X11 and Wayland so feature detection lines up with what
  # upstream's external.sh build produces.
  buildInputs = with pkgs; [
    # X11 backend
    libX11
    libXext
    libXcursor
    libXi
    libXfixes
    libXrandr
    libXrender
    libXScrnSaver
    # Wayland backend
    wayland
    wayland-protocols
    libxkbcommon
    libdecor
  ];

  cmakeFlags = [
    "-DSDL_SHARED=ON"
    "-DSDL_STATIC=OFF"
    "-DSDL_TEST_LIBRARY=OFF"
    "-DSDL_OPENGLES=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];
}
