{ config, pkgs, lib, ... }:

{
  boot = {
    blacklistedKernelModules = [ ];
    extraModulePackages = with config.boot.kernelPackages; [ ];
    initrd.kernelModules = [ ];
    kernelParams = [ ];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  boot.loader = {
    systemd-boot.enable = true;

    grub.enable = lib.mkForce false;

    # Timeout until we go into the latest generation automatically. If not
    # working, get rid of state via:
    # `bootctl set-default && sudo bootctl set-timeout`
    timeout = lib.mkForce 1;
  };
}
