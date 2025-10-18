{ pkgs, lib, ... }:

{
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  services.gnome = {
    core-apps.enable = false;
  };
}
