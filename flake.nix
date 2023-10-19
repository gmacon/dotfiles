{
  description = "Home Manager configuration of George Macon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:nix-community/emacs-overlay";
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
    { nixpkgs, home-manager, emacs, nix-index-database, ... } @ inputs:
    let
      extraSpecialArgs = { inherit inputs; };
      nixpkgsArgs = {
        overlays = [
          emacs.overlays.default
          (import ./nix/overlay.nix)
        ];
        config.allowUnfreePredicate = pkg: builtins.elem (pkg.pname) [
          "1password"
          "1password-cli"
          "slack"
        ];
      };
      linuxPkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-linux"; });
      darwinPkgs =
        import nixpkgs (nixpkgsArgs // { system = "x86_64-darwin"; });
    in
    {
      homeConfigurations.work-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;

          modules = [
            nix-index-database.hmModules.nix-index
            ./common.nix
            ./graphical.nix
            ./darwin.nix
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
            ./common.nix
            ./graphical.nix
            ./linux.nix
            ./rclone.nix
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
            ./common.nix
            ./linux.nix
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
            ./common.nix
            ./graphical.nix
            ./linux.nix
          ];

          extraSpecialArgs = {
            username = "gmacon";
            userEmail = "george.macon@gmail.com";
            homeDirectory = "/home/gmacon";
          } // extraSpecialArgs;
        };
    };
}
