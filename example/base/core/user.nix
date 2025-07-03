{ hostVars, ... }:
{
  users.users.${hostVars.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
