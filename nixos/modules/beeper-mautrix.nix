bridgeName:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services."beeper-mautrix-${bridgeName}";
  dataDir = "/var/lib/beeper-mautrix-${bridgeName}";
  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnsubstituted = settingsFormat.generate "beeper-mautrix-${bridgeName}-config-unsubstituted.json" cfg.settings;
  settingsFormat = pkgs.formats.json { };
  appservicePort = 29328;

  # to be used with a list of lib.mkIf values
  optOneOf = lib.lists.findFirst (value: value.condition) (lib.mkIf false null);
  mkDefaults = lib.mapAttrsRecursive (n: v: lib.mkDefault v);
  defaultConfig = {
    homeserver.address = "http://localhost:8448";
    appservice = {
      hostname = "[::]";
      port = appservicePort;
      database.type = "sqlite3";
      database.uri = "file:${dataDir}/beeper-mautrix-${bridgeName}.db?_txlock=immediate";
      id = "${bridgeName}";
      bot = {
        username = "${bridgeName}bot";
        displayname = "${bridgeName} Bridge Bot";
      };
      as_token = "";
      hs_token = "";
    };
    bridge = {
      username_template = "${bridgeName}_{{.}}";
      displayname_template = "{{or .ProfileName .PhoneNumber \"Unknown user\"}}";
      double_puppet_server_map = { };
      login_shared_secret_map = { };
      command_prefix = "!${bridgeName}";
      permissions."*" = "relay";
      relay.enabled = true;
    };
    logging = {
      min_level = "info";
      writers = lib.singleton {
        type = "stdout";
        format = "pretty-colored";
        time_format = " ";
      };
    };
  };

in
{
  options.services."beeper-mautrix-${bridgeName}" = {
    enable = lib.mkEnableOption "beeper-mautrix-${bridgeName}, a Matrix-${bridgeName} puppeting bridge.";

    settings = lib.mkOption {
      apply = lib.recursiveUpdate defaultConfig;
      type = settingsFormat.type;
      default = defaultConfig;
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/beeper-mautrix/${bridgeName}/blob/master/example-config.yaml).
        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
      example = {
        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///beeper-mautrix_${bridgeName}?host=/run/postgresql";
          };
          id = "${bridgeName}";
          ephemeral_events = false;
        };
        bridge = {
          history_sync = {
            request_full_sync = true;
          };
          private_chat_portal_meta = true;
          mute_bridging = true;
          encryption = {
            allow = true;
            default = true;
            require = true;
          };
          provisioning = {
            shared_secret = "disable";
          };
          permissions = {
            "example.com" = "user";
          };
        };
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the beeper-mautrix-${bridgeName} service.
      '';
    };

    serviceDependencies = lib.mkOption {
      type = with lib.types; listOf str;
      default =
        (lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (lib.optional config.services.matrix-conduit.enable "conduit.service");
      defaultText = lib.literalExpression ''
        (optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (optional config.services.matrix-conduit.enable "conduit.service")
      '';
      description = ''
        List of systemd units to require and wait for when starting the application service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    users.users."beeper-mautrix-${bridgeName}" = {
      isSystemUser = true;
      group = "beeper-mautrix-${bridgeName}";
      home = dataDir;
      description = "Beeper-Mautrix-${bridgeName} bridge user";
    };

    users.groups."beeper-mautrix-${bridgeName}" = { };

    # Note: this is defined here to avoid the docs depending on `config`
    services."beeper-mautrix-${bridgeName}".settings.homeserver = optOneOf (
      with config.services;
      [
        (lib.mkIf matrix-synapse.enable (mkDefaults {
          domain = matrix-synapse.settings.server_name;
        }))
        (lib.mkIf matrix-conduit.enable (mkDefaults {
          domain = matrix-conduit.settings.global.server_name;
          address = "http://localhost:${toString matrix-conduit.settings.global.port}";
        }))
      ]
    );

    systemd.services."beeper-mautrix-${bridgeName}" = {
      description = "beeper-mautrix-${bridgeName}, a Matrix-${bridgeName} puppeting bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      # ffmpeg is required for conversion of voice messages
      path = [ pkgs.ffmpeg-headless ];

      preStart = ''
        # substitute the settings file by environment variables
        # in this case read from EnvironmentFile
        test -f '${settingsFile}' && rm -f '${settingsFile}'
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o '${settingsFile}' \
          -i '${settingsFileUnsubstituted}'
        umask $old_umask
      '';

      serviceConfig = {
        User = "beeper-mautrix-${bridgeName}";
        Group = "beeper-mautrix-${bridgeName}";
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = baseNameOf dataDir;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${pkgs."mautrix-${bridgeName}"}/bin/mautrix-${bridgeName} \
          --config='${settingsFile}'
        '';
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];
        Type = "simple";
        UMask = 27;
      };
      restartTriggers = [ settingsFileUnsubstituted ];
    };
  };
  meta.maintainers = with lib.maintainers; [ niklaskorz ];
}
