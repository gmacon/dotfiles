{
  description = "Home Manager configuration of George Macon";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org/"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
    { self
    , agenix
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
          ./argon/display-switch.nix
          nixos-hardware.nixosModules.framework-13th-gen-intel
          ./argon/hardware-configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gmacon.imports = [
              nix-index-database.hmModules.nix-index
              ./home-manager/common/common.nix
              ./home-manager/common/linux.nix
              ./home-manager/graphical/common.nix
              ./home-manager/graphical/linux.nix
              ./home-manager/home/common.nix
            ];
            home-manager.extraSpecialArgs = {
              username = "gmacon";
              userEmail = "george@themacons.net";
              homeDirectory = "/home/gmacon";
            } // extraSpecialArgs;
          }
        ];
      };

      nixosConfigurations.potassium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            system.stateVersion = "23.11";
            fileSystems."/srv" = {
              device = "/dev/disk/by-id/scsi-0DO_Volume_volume-nyc3-01";
              options = [ "discard" "nofail" "noatime" ];
            };
            services.openssh.ports = [ 46409 ];
          }
          nixpkgsModule
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-config.nix"
          ./potassium/web-server.nix
        ];
      };

      homeConfigurations.work-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./home-manager/common/common.nix
            ./home-manager/common/darwin.nix
            ./home-manager/graphical/common.nix
            ./home-manager/work/common.nix
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
            ./home-manager/common/common.nix
            ./home-manager/common/linux.nix
            ./home-manager/common/alien-linux.nix
            ./home-manager/graphical/common.nix
            ./home-manager/graphical/linux.nix
            ./home-manager/work/common.nix
            ./home-manager/work-graphical/linux.nix
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
            ./home-manager/common/common.nix
            ./home-manager/common/linux.nix
            ./home-manager/common/alien-linux.nix
            ./home-manager/work/common.nix
          ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/home/gmacon3";
          } // extraSpecialArgs;
        };

      legacyPackages = {
        x86_64-linux = linuxPkgs;
        x86_64-darwin = darwinPkgs;
      };
      devShells = builtins.mapAttrs
        (system: pkgs:
          {
            default = pkgs.mkShell {
              packages = [ agenix.packages.${system}.default ];
            };
          })
        self.legacyPackages;
    };
}
