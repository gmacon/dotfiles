# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f5b58870-34bb-4c82-b229-eb6f949c3ac9";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-ea7ac1b1-e2b3-4e8c-ac68-a9864d91cdda".device = "/dev/disk/by-uuid/ea7ac1b1-e2b3-4e8c-ac68-a9864d91cdda";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0285-F1F8";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/c667f835-6206-4200-bbe6-3ab738f90199"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u4u2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
