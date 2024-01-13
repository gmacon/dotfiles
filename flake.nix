{
  description = "Home Manager configuration of George Macon";

  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org/";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake_env = {
      url = "sourcehut:~bryan_bennett/flake_env";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-direnv = {
      url = "github:nix-community/nix-direnv/3.0.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    penumbra = {
      url = "github:nealmckee/penumbra";
      flake = false;
    };
    zsh-fzf-marks = {
      url = "github:urbainvaes/fzf-marks";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, emacs, flake_env, nix-direnv, nix-index-database, ... } @ inputs:
    let
      extraSpecialArgs = { inherit inputs; };
      nixpkgsArgs = {
        overlays = [
          emacs.overlays.default
          flake_env.overlays.default
          nix-direnv.overlays.default
          (import ./nix/overlay.nix)
        ];
        config = {
          allowUnfreePredicate = pkg: builtins.elem (pkg.pname) [
            "1password"
            "1password-cli"
            "slack"
          ];
          permittedInsecurePackages = [
            # CVE-2023-5217
            # This vuln only affects the VP8 *encoder*, so I'm not too worried.
            "zotero-6.0.26"
          ];
        };
      };
      linuxPkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-linux"; });
      darwinPkgs =
        import nixpkgs (nixpkgsArgs // { system = "x86_64-darwin"; });
    in
    {
      nixosConfigurations.argon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./argon/configuration.nix
          ./argon/hardware-configuration.nix
        ];
      };
      homeConfigurations.work-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./common/common.nix
            ./common/darwin.nix
            ./graphical/common.nix
            ./work/common.nix
          ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/Users/gmacon3";
          } // extraSpecialArgs;
        };
      homeConfigurations.work-desktop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./common/common.nix
            ./common/linux.nix
            ./graphical/common.nix
            ./graphical/linux.nix
            ./work/common.nix
            ./work-graphical/linux.nix
          ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/home/gmacon3";
          } // extraSpecialArgs;
        };
      homeConfigurations.work-server =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./common/common.nix
            ./common/linux.nix
            ./work/common.nix
          ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/home/gmacon3";
          } // extraSpecialArgs;
        };
      homeConfigurations.home-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./common/common.nix
            ./common/linux.nix
            ./graphical/common.nix
            ./graphical/linux.nix
            ./home/common.nix
          ];

          extraSpecialArgs = {
            username = "gmacon";
            userEmail = "george.macon@gmail.com";
            homeDirectory = "/home/gmacon";
          } // extraSpecialArgs;
        };
    };
}
