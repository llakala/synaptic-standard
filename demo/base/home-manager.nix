{ lib, inputs, baseVars, hostVars, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    # Let us use hm as shorthand for home-manager config
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" baseVars.username ])
  ];

  hm.home.stateVersion = hostVars.stateVersion;
}
