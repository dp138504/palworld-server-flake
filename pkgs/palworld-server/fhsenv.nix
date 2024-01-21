{
  lib,
  buildFHSUserEnv,
  writeScript,
  palworld-server-unwrapped,
  steamworks-sdk-redist,
}:

buildFHSUserEnv {
  name = "palworld-server";

  runScript = "${palworld-server-unwrapped}/PalServer.sh";

  targetPkgs = pkgs: [
    palworld-server-unwrapped
    steamworks-sdk-redist
  ];

  inherit (palworld-server-unwrapped) meta;
}
