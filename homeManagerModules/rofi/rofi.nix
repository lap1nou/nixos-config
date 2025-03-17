{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.rofi.enable = lib.mkEnableOption "enables rofi";
  };

  config = lib.mkIf config.homeManagerModules.rofi.enable {
    programs.rofi = {
      enable = true;
      extraConfig = lib.mkMerge [
        {
          show-icons = true;
          icon-theme = "Papirus";
          modi = "drun";
          combi-modi = "drun";
          terminal = "kitty";
          display-drun = "    Run  ";
          drun-display-format = "{icon} {name}";
        }
      ];

      theme = {
        window = {
          width = config.lib.formats.rasi.mkLiteral "280px";
          x-offset = config.lib.formats.rasi.mkLiteral "4px";
          y-offset = config.lib.formats.rasi.mkLiteral "26px";
          border = config.lib.formats.rasi.mkLiteral "2px";
          border-radius = config.lib.formats.rasi.mkLiteral "15px";
        };

        element = {
          padding = config.lib.formats.rasi.mkLiteral "4px 8px";
          spacing = config.lib.formats.rasi.mkLiteral "8px";
        };

        "element selectedactive" = {
          text-color = lib.mkForce (config.lib.formats.rasi.mkLiteral "#f7768e");
          background-color = lib.mkForce (config.lib.formats.rasi.mkLiteral "#f7768e");
        };

        "element normal.urgent" = {
          background-color = lib.mkForce "#f7768e";
          text-color = lib.mkForce "#f7768e";
        };

        "*" = {
          margin = 0;
          padding = 0;
          spacing = 0;
          border = "2px";
          border-radius = "15px";
        };

        element.text-color = "#f7768e";
      };
    };
  };
}
