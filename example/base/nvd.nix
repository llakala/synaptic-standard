{ pkgs, config, lib, ... }:

{
  environment.systemPackages = with pkgs;
  [
    nvd
  ];

  # Runs on every rebuild. Used instead of diff-closures because output is more detailed
  system.activationScripts.diff = # bash
  ''
    nvd --color=always --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
  '';
}
