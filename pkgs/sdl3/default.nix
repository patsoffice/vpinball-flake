{
  lib,
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

  buildInputs = with pkgs; [
    libX11
    libxcb
    libXext
    libXcursor
    libXi
    libXfixes
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    wayland
    wayland-protocols
    libxkbcommon
    libdecor
  ];

  # NOTE: upstream vpinball's platforms/external.sh does NOT pass
  # -DSDL_X11/-DSDL_WAYLAND — it relies on CMake auto-detection. We pin
  # both ON explicitly so that if a backend dep is missing from
  # buildInputs, configure fails loudly instead of silently producing a
  # half-enabled Wayland backend that crashes at runtime.
  # TODO: push this upstream to platforms/external.sh so the divergence
  # goes away and every downstream packager gets the loud-failure behavior.
  cmakeFlags = [
    "-DSDL_SHARED=ON"
    "-DSDL_STATIC=OFF"
    "-DSDL_TEST_LIBRARY=OFF"
    "-DSDL_OPENGLES=OFF"
    "-DSDL_X11=ON"
    "-DSDL_WAYLAND=ON"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    description = "Simple DirectMedia Layer 3, a cross-platform development library for multimedia";
    homepage = "https://github.com/libsdl-org/SDL";
    license = licenses.zlib;
    platforms = platforms.linux;
  };
}
