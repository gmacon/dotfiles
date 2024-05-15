{
  # Replace Tarsnap module with our modified version
  disabledModules = [ "services/backup/tarsnap.nix" ];
  imports = [ ./modules/tarsnap.nix ];
}
