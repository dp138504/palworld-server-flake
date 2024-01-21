{
  description = "NixOS module for the Palworld dedicated server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    steam-fetcher = {
      url = "github:aidalgol/nix-steam-fetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    flake-parts,
    steam-fetcher,
    ...
  }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];
    perSystem = { config, self', inputs', pkgs, system, ... }: { };
    flake = {
      nixosModules = rec {
        palworld-server = import ./nixos-modules/palworld-server.nix {inherit self steam-fetcher;};
        default = palworld-server;
      };
      overlays.default = final: prev: {
        palworld-server-unwrapped = final.callPackage ./pkgs/palworld-server {};
        palworld-server = final.callPackage ./pkgs/palworld-server/fhsenv.nix {};
      };
    };
  };
}
