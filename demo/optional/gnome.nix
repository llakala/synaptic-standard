{ pkgs, lib, ... }:

{
  services.desktopManager.gnome.enable = true;

  services.gnome = {
    # Disable Events and Tasks Reminders from always running in the background
    evolution-data-server.enable = lib.mkForce false;
  };

  # Logout of gnome, very helpful for applying changes to `environment.variables`
  environment.shellAliases.logout = "kill -9 -1";
}
