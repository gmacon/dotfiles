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
    # Nixpkgs branches
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Flakes used locally
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.systems.follows = "systems_";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.flake-utils.follows = "flake-utils_";
    };
    flake_env = {
      url = "sourcehut:~bryan_bennett/flake_env";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.git-hooks.follows = "git-hooks_";
      inputs.flake-parts.follows = "flake-parts_";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.pre-commit-hooks-nix.follows = "git-hooks_";
      inputs.flake-parts.follows = "flake-parts_";
      inputs.flake-utils.follows = "flake-utils_";
      inputs.flake-compat.follows = "flake-compat_";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-utils.follows = "flake-utils_";
    };
    nix-direnv = {
      url = "github:nix-community/nix-direnv/3.0.5";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-parts.follows = "flake-parts_";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Flakes only needed to reduce duplication
    flake-compat_.url = "github:edolstra/flake-compat";
    flake-parts_ = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-stable";
    };
    flake-utils_ = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems_";
    };
    git-hooks_ = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nixpkgs-stable.follows = "";
      inputs.flake-compat.follows = "flake-compat_";
    };
    systems_.url = "github:nix-systems/default";

    # Non-flake inputs
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
    {
      self,
      agenix,
      emacs,
      flake_env,
      home-manager,
      lanzaboote,
      lix-module,
      nix-direnv,
      nix-index-database,
      nixos-hardware,
      nixpkgs,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      nixpkgsModule = {
        nixpkgs = {
          overlays = [
            emacs.overlays.default
            flake_env.overlays.default
            nix-direnv.overlays.default
            (import ./nix/overlay.nix)
            (self: super: {
              beeper = (self.callPackage "${nixpkgs}/pkgs/applications/networking/instant-messengers/beeper" { });
            })
          ];
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              # Non-constant-time crypto primitives.
              # In the mautrix bridges,
              # I feel like this is low risk
              # since I'm controlling both endpoints.
              "olm-3.2.16"
            ];
          };
        };
        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
          keep-outputs = true;
          keep-derivations = true;
          auto-optimise-store = true;
        };
      };
      nixpkgsArgs = {
        inherit (nixpkgsModule.nixpkgs) overlays config;
      };
      linuxPkgs = import nixpkgs-stable (nixpkgsArgs // { system = "x86_64-linux"; });
      darwinPkgs = import nixpkgs-stable (nixpkgsArgs // { system = "x86_64-darwin"; });
      unstablePkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-linux"; });
      extraSpecialArgs = {
        inherit inputs unstablePkgs;
      };
    in
    {
      nixosConfigurations.argon = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          nixpkgsModule
          lanzaboote.nixosModules.lanzaboote
          ./nixos/secure-boot.nix
          ./nixos/tarsnap.nix
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

      nixosConfigurations."potassium.kj4jzy.org" = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          nixpkgsModule
          "${nixpkgs-stable}/nixos/modules/virtualisation/digital-ocean-config.nix"
          ./nixos/tarsnap.nix
          ./potassium/configuration.nix
          agenix.nixosModules.default
          ./potassium/web-server.nix
          ./nixos/autoupgrade.nix
        ];
      };

      nixosConfigurations.silicon = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          lix-module.nixosModules.default
          nixpkgsModule
          nixos-hardware.nixosModules.raspberry-pi-4
          agenix.nixosModules.default
          ./silicon/configuration.nix
          ./nixos/autoupgrade.nix
          (import ./nixos/modules/beeper-mautrix.nix "signal")
          (import ./nixos/modules/beeper-mautrix.nix "discord")
          (import ./nixos/modules/beeper-mautrix.nix "gmessages")
          ./nixos/beeper-bridges
        ];
      };

      homeConfigurations.work-laptop = home-manager.lib.homeManagerConfiguration {
        pkgs = darwinPkgs;

        modules = [
          nix-index-database.hmModules.nix-index
          ./home-manager/common/common.nix
          ./home-manager/common/darwin.nix
          ./home-manager/graphical/common.nix
          ./home-manager/work/common.nix
        ];

        extraSpecialArgs =
          {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/Users/gmacon3";
          }
          // extraSpecialArgs
          // {
            unstablePkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-darwin"; });
          };
      };

      homeConfigurations.work-desktop = home-manager.lib.homeManagerConfiguration {
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

      homeConfigurations.work-server = home-manager.lib.homeManagerConfiguration {
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
        aarch64-linux = import nixpkgs-stable (nixpkgsArgs // { system = "aarch64-linux"; });
        x86_64-linux = linuxPkgs;
        x86_64-darwin = darwinPkgs;
      };
      devShells = builtins.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          packages = [
            agenix.packages.${system}.default
            pkgs.bridge-manager
            pkgs.yq-go
          ];
        };
      }) self.legacyPackages;
    };
}
