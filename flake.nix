{
  description = "Home Manager configuration of George Macon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    {
      homeConfigurations.work-laptop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";

        modules = [
          ./home.nix
          ./darwin.nix
        ];

        extraSpecialArgs = {
          username = "gmacon3";
          userEmail = "george.macon@gtri.gatech.edu";
          homeDirectory = "/Users/gmacon3";
        };
      };
      homeConfigurations.home-laptop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";

        modules = [
          ./home.nix
        ];

        extraSpecialArgs = {
          username = "gmacon";
          userEmail = "george.macon@gmail.com";
          homeDirectory = "/home/gmacon";
        };
      };
    };
}
