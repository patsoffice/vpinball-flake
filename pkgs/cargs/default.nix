{
  lib,
  stdenv,
  pkgs,
  inputs,
  buildType ? "Release",
}:
stdenv.mkDerivation {
  name = "cargs";

  src = inputs.cargs;

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_TYPE=${buildType}"
  ];
  meta = with lib; {
    description = "Simple command line argument parser library written in pure C";
    homepage = "https://github.com/likle/cargs";
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
