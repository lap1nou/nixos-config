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

    # Add useX11LegacyScreenshot=true in the future
    home-manager.users.lapinou.home.file = {
      ".config/flameshot/flameshot.ini" = {
        text = ''
          [General]
          contrastOpacity=188
          drawColor=#42ff00
          showDesktopNotification=true
        ''; # https://github.com/nix-community/home-manager/issues/9201
      };
    };

    home-manager.users.lapinou.programs.autorandr = {
      enable = true;
      profiles = {
      "vmware" = {
        fingerprint = {
          "Virtual-1" =  "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
        };

        config = {
          "Virtual-1" = {
            enable = true;
            crtc = 0;
            mode = "1918x920";
            position = "0x0";
            rate = "60.00";
          };
        };
      };

      "vmware-fullscreen-2" = {
        fingerprint = {
          "Virtual-1" =  "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
          "Virtual-2" =  "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-2";
        };

        config = {
          "Virtual-1" = {
            enable = true;
            crtc = 0;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };

          "Virtual-2" = {
            enable = true;
            crtc = 1;
            mode = "1920x1080";
            position = "1920x0";
            rate = "60.00";
          };
        };
      };
    };
  };

    services.xserver.windowManager.awesome = {
      enable = true;
      #package = awesome;

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

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --batch -c"
    '';

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
