let
  sources = import ./npins;
in
{
  meta = {
    nixpkgs = import sources.nixpkgs-stable;
    specialArgs = { inherit sources; };
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
}
