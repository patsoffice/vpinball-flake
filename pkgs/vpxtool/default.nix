{
  lib,
  pkgs,
  inputs,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  name = "vpxtool";
  #version = inputs.vpxtool.ref; # Placeholder version, can be updated later

  src = inputs.vpxtool;

  cargoLock = {
    lockFile = "${inputs.vpxtool}/Cargo.lock";
  };

  buildInputs = [
    pkgs.openssl
    pkgs.pkg-config
  ];

  meta = with lib; {
    description = "A command line tool to manipulate VPX (Visual Pinball X) files";
    homepage = "https://github.com/francisdb/vpxtool";
    license = licenses.mit; # Assuming MIT license based on common Rust projects
    #maintainers = with maintainers; [ ]; # To be filled by the user if desired
    platforms = platforms.linux; # Assuming Linux for now
  };
}
