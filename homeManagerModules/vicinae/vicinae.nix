{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.vicinae.enable = lib.mkEnableOption "enables vicinae";
  };

  config = lib.mkIf config.homeManagerModules.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      systemd.autoStart = true;
    };

    # https://github.com/nix-community/home-manager/issues/8151
    systemd.user.services.vicinae.Service.Environment = [
      "PATH=/run/current-system/sw/bin:/home/lapinou/.local/bin/:/home/lapinou/.nix-profile/bin/"
    ];
  };
}
