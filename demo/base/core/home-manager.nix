{ lib, inputs, hostVars, config, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    # Let us use hm as shorthand for home-manager config
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" hostVars.username ])
  ];

  hm.home.stateVersion = config.system.stateVersion;
}
