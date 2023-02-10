{
  description = "Home Manager configuration of George Macon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-fzf-marks = {
      url = "github:urbainvaes/fzf-marks";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs, zsh-fzf-marks }:
    let
      extraSpecialArgs = { inherit zsh-fzf-marks; };
      nixpkgsArgs = { overlays = [ emacs.overlays.default ]; };
      linuxPkgs = import nixpkgs (nixpkgsArgs // { system = "x86_64-linux"; });
      darwinPkgs =
        import nixpkgs (nixpkgsArgs // { system = "x86_64-darwin"; });
    in
    {
      homeConfigurations.work-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;

          modules = [ ./common.nix ./darwin.nix ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/Users/gmacon3";
          } // extraSpecialArgs;
        };
      homeConfigurations.work-desktop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [ ./common.nix ./linux.nix ];

          extraSpecialArgs = {
            username = "gmacon3";
            userEmail = "george.macon@gtri.gatech.edu";
            homeDirectory = "/home/gmacon3";
          } // extraSpecialArgs;
        };
      homeConfigurations.home-laptop =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [ ./common.nix ./linux.nix ];

          extraSpecialArgs = {
            username = "gmacon";
            userEmail = "george.macon@gmail.com";
            homeDirectory = "/home/gmacon";
          } // extraSpecialArgs;
        };
    };
}
