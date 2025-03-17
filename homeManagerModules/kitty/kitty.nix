{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.kitty.enable = lib.mkEnableOption "enables kitty";
  };

  config = lib.mkIf config.homeManagerModules.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        scrollback_lines = -1;
        #allow_remote_control = "yes";
        tab_bar_edge = "top";
        enable_audio_bell = false;
      };
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+u" = ''remote_control send-text "exh apply creds\\n"'';
      };
    };
  };
}
