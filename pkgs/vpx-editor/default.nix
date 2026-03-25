{
  lib,
  buildNpmPackage,
  fetchurl,
  inputs,
  electron,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  electronZip = fetchurl {
    url = "https://github.com/electron/electron/releases/download/v39.2.5/electron-v39.2.5-linux-x64.zip";
    hash = "sha256-YQxg5rqCTX0Yc+rBeR7SzR8qM2myeBnZ0w2lFlUVCS8=";
  };
  electronShasums = fetchurl {
    url = "https://github.com/electron/electron/releases/download/v39.2.5/SHASUMS256.txt";
    hash = "sha256-oLYplVh79/eJU4brOb0UO3Ti7nAlFuMmOeob5OVK9nE=";
  };
in
buildNpmPackage rec {
  pname = "vpx-editor";
  version = "0.8.25";

  src = inputs.vpx-editor;

  npmDepsHash = "sha256-56/B+I0Wgu6jdECJXfnK1SynwfRdQoM/JmS2mgqO/VM=";
  makeCacheWritable = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_GET_USE_LOCAL_CACHE = "1";
  };

  buildPhase = ''
    runHook preBuild

    npm run build:web

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/vpx-editor
    cp -r dist-web/* $out/share/vpx-editor/

    cat > $out/share/vpx-editor/package.json <<EOF
    {
      "name": "vpx-editor",
      "main": "main.js"
    }
    EOF

    cat > $out/share/vpx-editor/main.js <<EOF
    const { app, BrowserWindow } = require('electron');
    const path = require('path');

    app.whenReady().then(() => {
      const win = new BrowserWindow({
        width: 1280,
        height: 720,
        webPreferences: {
          nodeIntegration: false,
          contextIsolation: true
        }
      });
      win.setMenu(null);
      win.loadFile(path.join(__dirname, 'index.html'));
    });
    
    app.on('window-all-closed', () => {
      if (process.platform !== 'darwin') app.quit();
    });
    EOF

    makeWrapper ${electron}/bin/electron $out/bin/vpx-editor \
      --add-flags $out/share/vpx-editor

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vpx-editor";
      exec = "vpx-editor";
      icon = "vpx-editor";
      desktopName = "VPX Editor";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Visual Pinball X Table Editor";
    homepage = "https://github.com/jsm174/vpx-editor";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "vpx-editor";
    platforms = platforms.linux;
  };
}