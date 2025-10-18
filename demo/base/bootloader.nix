{ pkgs, lib, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    grub.enable = lib.mkForce false;
  };
}
