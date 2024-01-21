{
  self,
  steam-fetcher,
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.palworld-server;
in {
  config.nixpkgs.overlays = [self.overlays.default steam-fetcher.overlays.default];

  options.services.palworld-server = {
    enable = lib.mkEnableOption (lib.mdDoc "Palworld Dedicated Server");

    port = lib.mkOption {
      type = lib.types.port;
      default = 8211;
      description = lib.mdDoc "The port on which to listen for incoming connections.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Whether to open ports in the firewall.";
    };

    # Any options you want to expose for the game server, which will vary from game to game.
  };

  config = {
    users = {
      users.palworld-server = {
        isSystemUser = true;
        group = "palworld-server";
        createHome = true;
        home = "/var/lib/palworld-server";
      };
      groups.palworld-server = {};
    };

    systemd.services.palworld-server = {
      description = "Palworld dedicated server";
      requires = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
          Type = "exec";
          User = "palworld-server";
          ExecStart = "${pkgs.palworld-server}/bin/palworld-server";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [
        cfg.port
        (cfg.port + 1) # Steam server browser
      ];
    };
  };
}
