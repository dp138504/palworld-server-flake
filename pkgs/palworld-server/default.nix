{ lib, stdenv, fetchSteam }:

stdenv.mkDerivation rec {
  name = "palworld-server";
  version = "0.1.0";
  src = fetchSteam {
    inherit name;
    appId = "2394010";
    depotId = "2394012";
    manifestId = "4603741190199642564";
    # Fetch a different branch. <https://partner.steamgames.com/doc/store/application/branches>
    # branch = "beta_name";
    # Enable debug logging from DepotDownloader.
    # debug = true;
    # Only download specific files
    # fileList = ["filename" "regex:(or|a|regex)"];
    hash = "sha256-NEnskCOl031yb0+jmsWkFHMZVVrRzM4BLLVZGko1Jk8=";
  };

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out 

    # You may need to fix permissions on the main executable.
    chmod +x $out/PalServer.sh

    # PalServer.sh tweaks
    chmod +x $out/Pal/Binaries/Linux/PalServer-Linux-Test
    sed -i '4d' $out/PalServer.sh

    runHook postInstall
  '';

  meta = with lib; {
    description = "Palworld Dedicated Server";
    homepage = "https://steamdb.info/app/2394010/";
    changelog = "https://store.steampowered.com/news/app/1623730";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode # Steam games are always going to contain some native binary component.
      binaryBytecode # e.g. Unity games using C#
    ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
  };
}
