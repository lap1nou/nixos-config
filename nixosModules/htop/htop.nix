{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    htop.enable = lib.mkEnableOption "enables htop";
  };

  config = lib.mkIf config.htop.enable {
    home-manager.users.lapinou.home.file = {
      ".config/htop/htoprc" = {
        source = ./htoprc;
      };
    };

    environment.systemPackages = with pkgs; [
      htop
    ];
  };
}
