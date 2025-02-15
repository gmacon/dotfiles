let
  sources = import ./npins;
in
{
  meta = {
    nixpkgs = import sources.nixpkgs-stable;
    specialArgs = { inherit sources; };
  };

  defaults =
    { lib, name, ... }:
    {
      networking.hostName = name;
      deployment = {
        targetUser = lib.mkDefault null;
        sshOptions = [
          "-o" "ConnectTimeout=30"
          "-o" "ServerAliveInterval=30"
          "-o" "ServerAliveCountMax=2"
        ];
      };
    };

  argon = {
    imports = [
      ./nixos/nixpkgs.nix
      ((import sources.lanzaboote).nixosModules.lanzaboote)
      ./nixos/secure-boot.nix
      ./nixos/common.nix
      ./nixos/tarsnap.nix
      ./argon/configuration.nix
      ./argon/display-switch.nix
      "${sources.nixos-hardware}/framework/13-inch/13th-gen-intel"
      ./argon/hardware-configuration.nix
      "${sources.agenix}/modules/age.nix"
      "${sources.home-manager}/nixos"
      (
        { config, lib, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.gmacon.imports = [
            # nix-index-database.hmModules.nix-index
            ./home-manager/common/common.nix
            ./home-manager/common/linux.nix
            ./home-manager/graphical/common.nix
            ./home-manager/graphical/linux.nix
            ./home-manager/home/common.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit sources;
            username = "gmacon";
            userEmail = "george@themacons.net";
            homeDirectory = "/home/gmacon";
            unstablePkgs = import sources.nixpkgs {
              inherit (config.nixpkgs) overlays config;
            };
          };
        }
      )
    ];
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  silicon = {
    nixpkgs.hostPlatform.system = "aarch64-linux";
    imports = [
      ./nixos/nixpkgs.nix
      ./nixos/common.nix
      "${sources.nixos-hardware}/raspberry-pi/4"
      "${sources.agenix}/modules/age.nix"
      ./silicon/configuration.nix
      (import ./nixos/modules/beeper-mautrix.nix "signal")
      (import ./nixos/modules/beeper-mautrix.nix "discord")
      (import ./nixos/modules/beeper-mautrix.nix "gmessages")
      ./nixos/beeper-bridges
    ];
    deployment = {
      buildOnTarget = true;
      targetHost = "silicon.tail6afb0.ts.net";
    };
  };

  potassium = {
    imports = [
      ./nixos/nixpkgs.nix
      ./nixos/common.nix
      "${sources.nixpkgs-stable}/nixos/modules/virtualisation/digital-ocean-config.nix"
      ./nixos/tarsnap.nix
      ./potassium/configuration.nix
      "${sources.agenix}/modules/age.nix"
      ./potassium/web-server.nix
    ];
    deployment = {
      targetHost = "potassium.kj4jzy.org";
      targetUser = "root";
    };
  };
}
