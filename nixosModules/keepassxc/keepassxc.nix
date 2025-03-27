{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    keepassxc.enable = lib.mkEnableOption "enables keepassxc";
  };

  config = lib.mkIf config.keepassxc.enable {
    # Keepassxc config
    home-manager.users.lapinou.home.file = {
      ".config/keepassxc/keepassxc.ini" = {
        text = ''
          [General]
          ConfigVersion=2

          [Browser]
          CustomProxyLocation=
          Enabled=true

          [GUI]
          ApplicationTheme=classic
          TrayIconAppearance=monochrome-light

          [Security]
          IconDownloadFallback=true
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
