{ config, lib, ... }:
{
  services =
    lib.genAttrs
      [
        "beeper-mautrix-discord"
        "beeper-mautrix-signal"
        "beeper-mautrix-gmessages"
      ]
      (name: {
        enable = true;
        environmentFile = config.age.secrets.${name}.path;
        settings = lib.importJSON ./${name}.json;
      });
}
