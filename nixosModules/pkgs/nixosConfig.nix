{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nixosConfig.enable = lib.mkEnableOption "enables nixosConfig";
  };

  config = lib.mkIf config.nixosConfig.enable {
    environment.systemPackages = with pkgs; [
      git-crypt
      nixos-generators
      home-manager
    ];
  };
}
