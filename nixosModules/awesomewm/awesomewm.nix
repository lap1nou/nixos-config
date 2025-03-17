{
  pkgs,
  lib,
  config,
  ...
}:
let
  awesome = pkgs.awesome.overrideAttrs (oa: {
    version = "0f950cbb625175134b45ea65acdf29b2cbe8c456";
    src = pkgs.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "0f950cbb625175134b45ea65acdf29b2cbe8c456";
      hash = "sha256-GIUkREl60vQ0cOalA37sCgn7Gv8j/9egfRk9emgGm/Y=";
    };

    patches = [ ];

    postPatch = ''
      patchShebangs tests/examples/_postprocess.lua
    '';
  });

  picomConfigFile = pkgs.writeTextFile {
    name = "picom.conf";
    text = builtins.readFile ./picom.conf;
  };
in
{
  options = {
    awesomewm.enable = lib.mkEnableOption "enables AwesomeWM";
  };

  config = lib.mkIf config.awesomewm.enable {
    home-manager.users.lapinou.home.file = {
      ".config/awesome" = {
        source = ./awesome;
      };
    };

    services.xserver.windowManager.awesome = {
      enable = true;
      package = awesome;

      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };

    services = {
      physlock = {
        enable = true;
        allowAnyUser = true;
      };
    };

    environment.systemPackages = with pkgs; [
      picom
    ];

    # Reference: https://www.reddit.com/r/NixOS/comments/15qdgw9/how_to_produce_type_libconfig_configuration_from/
    systemd.user.services.picom = {
      description = "Picom composite manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.picom} --config ${picomConfigFile}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment = {
      sessionVariables = rec {
        ADW_DISABLE_PORTAL = 1;
        GTK_CSD = "0"; # Disable GTK CSD (Client-side decoration) such as the mini close button on Firefox (that d'oesn't go well with Awesomewm for example)
      };
    };
  };
}
