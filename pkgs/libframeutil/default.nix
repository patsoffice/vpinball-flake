{
  stdenv,
  inputs,
}:
stdenv.mkDerivation {
  name = "libframeutil";

  src = inputs.libframeutil;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r include/* $out/include/

    runHook postInstall
  '';
}
