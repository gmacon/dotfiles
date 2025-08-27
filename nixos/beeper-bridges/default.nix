{ config, lib, ... }:
{
  services =
    lib.genAttrs
      [
        "beeper-mautrix-discord"
      ]
      (name: {
        enable = true;
        environmentFile = config.age.secrets.${name}.path;
        settings = lib.importJSON ./${name}.json;
      });
}
