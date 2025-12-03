{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    programming.enable = lib.mkEnableOption "enables programming";
  };

  config = lib.mkIf config.programming.enable {
    environment.systemPackages = with pkgs; [
      devbox
      gum
      python3
      pipx
    ];
  };
}
