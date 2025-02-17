let
  sources = import ../npins;
  system-manager = import sources.system-manager { nixpkgs = sources.nixpkgs-stable; };
in
{
  work-desktop = system-manager.lib.makeSystemConfig {
    modules = [
      (import "${sources.nix-system-graphics}/system/modules/graphics.nix")
      {
        config = {
          nixpkgs.hostPlatform = "x86_64-linux";
          system-graphics.enable = true;
        };
      }
    ];
  };
}
