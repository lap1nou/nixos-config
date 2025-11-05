{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nano.enable = lib.mkEnableOption "enables nano";
  };

  config = lib.mkIf config.nano.enable {
    home-manager.users.lapinou.home.file = {
        ".local/share/applications/nano.desktop".text = ''
          [Desktop Entry]
          Name=Nano
          Comment=Nano
          Exec=nano
          Terminal=true
          Type=Application
        '';

        ".nanorc".text = ''
          set mouse
          set constantshow
          set indicator
          set autoindent
          set tabsize 2
          set tabstospaces

          include ${pkgs.nanorc}/share/*.nanorc
        '';
    };

    environment.systemPackages = with pkgs; [
      nano
      nanorc # https://github.com/scopatz/nanorc
    ];
  };
}
