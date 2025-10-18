{ hostVars, baseVars, ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = hostVars.hostname;
  };
  users.users.${baseVars.username}.extraGroups = [ "networkmanager" ];
}
