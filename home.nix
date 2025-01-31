let
  sources = import ./npins;
  extraSpecialArgs = {
    inherit sources;
    unstablePkgs = import sources.nixpkgs { };
    username = "gmacon3";
    userEmail = "george.macon@gtri.gatech.edu";
    homeDirectory = "/home/gmacon3";
  };
in
{
  work-laptop = {
    imports = [
      ./nixos/nixpkgs.nix
      ./home-manager/common/common.nix
      ./home-manager/common/darwin.nix
      ./home-manager/graphical/common.nix
      ./home-manager/work/common.nix
    ];
    _module.args = extraSpecialArgs // {
      homeDirectory = "/Users/gmacon3";
    };
  };

  work-desktop = {
    imports = [
      ./nixos/nixpkgs.nix
      ./home-manager/common/common.nix
      ./home-manager/common/linux.nix
      ./home-manager/common/alien-linux.nix
      ./home-manager/graphical/common.nix
      ./home-manager/graphical/linux.nix
      ./home-manager/work/common.nix
      ./home-manager/work-graphical/linux.nix
    ];

    _module.args = extraSpecialArgs;
  };

  work-server = {
    imports = [
      ./nixos/nixpkgs.nix
      ./home-manager/common/common.nix
      ./home-manager/common/linux.nix
      ./home-manager/common/alien-linux.nix
      ./home-manager/work/common.nix
    ];

    _module.args = extraSpecialArgs;
  };
}
