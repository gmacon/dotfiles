{
  description = "Home Manager configuration of George Macon";

  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org/";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    alacritty-theme-penumbra = {
      url = "github:pomarec/alacritty-theme-penumbra";
      flake = false;
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
    { agenix
    , emacs
    , flake_env
    , home-manager
    , nix-direnv
    , nix-index-database
    , nixos-hardware
    , nixpkgs
    , nixpkgs-unstable
    , ...
    } @ inputs:
    let
      nixpkgsModule = {
        nixpkgs = {
          overlays = [
            emacs.overlays.default
            flake_env.overlays.default
            nix-direnv.overlays.default
            (import ./nix/overlay.nix)
          ];
          config.allowUnfree = true;
        };
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
          trusted-users = [ "root" "@wheel" ];
          keep-outputs = true;
          keep-derivations = true;
        };
      };
      nixpkgsArgs = {
        inherit (nixpkgsModule.nixpkgs) overlays config;
      };
      linuxPkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-linux"; });
      darwinPkgs =
        import nixpkgs (nixpkgsArgs // { system = "x86_64-darwin"; });
      unstablePkgs = import nixpkgs-unstable (nixpkgsArgs // { system = "x86_64-linux"; });
      extraSpecialArgs = { inherit inputs unstablePkgs; };
    in
    {
      nixosConfigurations.argon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./argon/configuration.nix
          nixos-hardware.nixosModules.framework-13th-gen-intel
          ./argon/hardware-configuration.nix
          agenix.nixosModules.default
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
            ./home/common.nix
          ];

          extraSpecialArgs = {
            username = "gmacon";
            userEmail = "george@themacons.net";
            homeDirectory = "/home/gmacon";
          } // extraSpecialArgs;
        };

      devShells = builtins.mapAttrs
        (system: pkgs:
          {
            default = pkgs.mkShell {
              packages = [ agenix.packages.${system}.default ];
            };
          })
        {
          "x86_64-linux" = linuxPkgs;
          "x86_64-darwin" = darwinPkgs;
        };
    };
}
