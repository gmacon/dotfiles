{
  config,
  pkgs,
  unstablePkgs,
  inputs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs) acsaml rclone tmux;
    inherit (unstablePkgs) rye uv;
  };

  # Vagrant
  home.file."${config.home.homeDirectory}/.vagrant.d/Vagrantfile".source = ../config/Vagrantfile;

  nix.registry.nixpkgs = {
    from = {
      id = "nixpkgs";
      type = "indirect";
    };
    flake = inputs.nixpkgs-stable;
  };
}
