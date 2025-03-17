{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    system.enable = lib.mkEnableOption "enables system";
  };

  config = lib.mkIf config.system.enable {
    environment.systemPackages = with pkgs; [
      alsa-utils # CLI to manage sound
      brightnessctl
      eza
      feh
      file
      moreutils
      pavucontrol
      networkmanagerapplet
      sbctl
      efitools
    ];

    programs.zsh.enable = true;
  };
}
