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

          nix.settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [ "gmacon3" ];
            keep-outputs = true;
            keep-derivations = true;
            auto-optimise-store = true;
            substituters = [ "https://cache.lix.systems" ];
            trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
          };
        };
      }
    ];
  };
}
