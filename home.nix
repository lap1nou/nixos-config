{ config, pkgs, fetchFromGitHub, lib, ... }:

{
  home.username = lib.mkForce "lapinou";
  home.homeDirectory = lib.mkForce "/home/lapinou";
  home.packages = [ 
    #(import ./pkgs/exegol/exegol.nix { inherit pkgs lib; })
    (import ./pkgs/htb-cli.nix { inherit pkgs lib; })
    (import ./pkgs/vagrant-vmware-utility/vagrant-vmware-utility.nix { inherit pkgs lib; })
  ];

  stylix.enable = true;
  stylix.polarity = "dark";

  # Some program should be installed this way in order for stylix to apply theme
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (
      ''
        # Source: https://github.com/theRubberDuckiee/dev-environment-files/blob/main/starship.toml
        format = """\
        [](#${config.stylix.generated.palette.base02})\
        $status\
        $os\
        $env_var\
        $directory\
        [](fg:#${config.stylix.generated.palette.base01} bg:#${config.stylix.generated.palette.base03})\
        $nix_shell\
        [](fg:#${config.stylix.generated.palette.base03} bg:#${config.stylix.generated.palette.base09})\
        $git_branch\
        $git_status\
        $git_metrics\
        [](fg:#${config.stylix.generated.palette.base09} bg:none)
        [ └>](bold green) 
        """

        [status]
        disabled = false
        style = "fg:bold red bg:#${config.stylix.generated.palette.base02}"
        format = '[✗ ]($style)'

        [os]
        style = "bg:#${config.stylix.generated.palette.base02}"
        disabled = false

        [directory]
        format = "[  $path ]($style)"
        style = "fg:#${config.stylix.generated.palette.base05} bg:#${config.stylix.generated.palette.base01}"
        truncation_length = 0

        [nix_shell]
        style = "bg:#${config.stylix.generated.palette.base03}"
        symbol = '❄️'
        format = '[[ $symbol nix-shell ](bg:#${config.stylix.generated.palette.base03} fg:#${config.stylix.generated.palette.base00})]($style)'

        [git_branch]
        format = '[ $symbol$branch(:$remote_branch) ]($style)'
        symbol = "  "
        style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"

        [git_status]
        format = '[$all_status]($style)'
        style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"

        [git_metrics]
        format = "([+$added]($added_style))[]($added_style)"
        added_style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"
        deleted_style = "fg:bright-red bg:235"
        disabled = false

        [character]
        style = "bg:#${config.stylix.generated.palette.base05}"
        success_symbol = ""
        error_symbol = "[✗](#${config.stylix.generated.palette.base05})"
      ''
    );
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ 
      ms-python.python
      ms-azuretools.vscode-docker
      pkief.material-icon-theme
      #rust-lang.rust-analyzer
      charliermarsh.ruff
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "sarif-viewer";
          publisher = "MS-SarifVSCode";
          version = "3.4.2";
          sha256 = "sha256-HDuDelX9kCK58Re8aTlKP+EJi4fSm5lejXsvxlMXRxM=";
        }
        {
          name = "devbox";
          publisher = "jetpack-io";
          version = "0.1.6";
          sha256 = "sha256-cPlMZzF3UNVJCz16TNPoiGknukEWXNNXnjZVMyp/Dz8=";
        }
      ];
  };
  programs.bat.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      scrollback_lines = 100000;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal = lib.mkForce {
        family = "monospace";
      };

      scrolling = {
        history = 100000;
      };

      selection = {
        save_to_clipboard = true;
      };
    };
  };
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
            margin  = 0;
            padding = 0;
            spacing = 0;
            border = "2px";
            border-radius = "15px";
          };

          element.text-color = "#f7768e";
      };
  };
  programs.git = {
    enable = true;
    userEmail = "lapinousexy@gmail.com";
    userName = "lap1nou";

    signing.signByDefault = true;

    extraConfig = {
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_rsa_github.pub";
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  xsession = {
    windowManager.awesome.enable = true;
  };

  home.file = {
    # Nautilus folder bookmarks
    "${config.xdg.configHome}/gtk-3.0/bookmarks".text = ''
      file:///etc/nixos/ nixos
      file://${config.home.homeDirectory}/.exegol/workspaces/ Exegol workspaces
      file://${config.home.homeDirectory}/.exegol/ .exegol
      file:///mount/shared/ shared
    '';

    # Wezterm
    #"${config.home.homeDirectory}/.wezterm.lua".source = ./pkgs/wezterm/.wezterm.lua;

    # Htop
    "${config.home.homeDirectory}/.config/htop".source = ./pkgs/htop;

    # Devbox
    "${config.home.homeDirectory}/.devbox".source = ./pkgs/devbox;

    # Awesomewm
    "${config.home.homeDirectory}/.config/awesome".source = ./pkgs/awesome;

    #Exegol
    "${config.home.homeDirectory}/.exegol/config.yml".source = ./pkgs/exegol/config.yml;
    # Exegol wrapper need the "my-resources" folder to have wider permissions
    # Dirty workaround: https://github.com/nix-community/home-manager/issues/3090#issuecomment-2010891733
    "${config.home.homeDirectory}/.exegol/HomeManagerInit_my-resources" = {
      source = ./pkgs/exegol/my-resources;
      onChange = ''
        rm -rf ${config.home.homeDirectory}/.exegol/my-resources
        cp -L -r ${config.home.homeDirectory}/.exegol/HomeManagerInit_my-resources ${config.home.homeDirectory}/.exegol/my-resources
        chmod -R 777 ${config.home.homeDirectory}/.exegol/my-resources
      '';
    };

    ".local/share/applications/org.flameshot.Flameshot.desktop".text =
    ''
      [Desktop Entry]
      Name=Flameshot
      GenericName=Screenshot tool2
      Comment=Powerful yet simple to use screenshot software.
      Keywords=flameshot;screenshot;capture;shutter;
      Exec=${pkgs.flameshot}/bin/flameshot gui
      Icon=org.flameshot.Flameshot
      Terminal=false
      Type=Application
      Categories=Graphics;
      StartupNotify=false
      StartupWMClass=flameshot
      Actions=Configure;Capture;Launcher;
      X-DBUS-StartupType=Unique
      X-DBUS-ServiceName=org.flameshot.Flameshot
      X-KDE-DBUS-Restricted-Interfaces=org.kde.kwin.Screenshot,org.kde.KWin.ScreenShot2
    '';

    ".local/share/applications/nemo.desktop".text =
    ''
      [Desktop Entry]
      Name=Files
      Comment=Access and organize files
      Exec=${pkgs.nemo}/bin/nemo %U
      Icon=${pkgs.nemo}/share/icons/hicolor/scalable/apps/nemo.svg
      # Translators: these are keywords of the file manager
      Keywords=folders;filesystem;explorer;
      Terminal=false
      Type=Application
      StartupNotify=false
      Categories=GNOME;GTK;Utility;Core;
      MimeType=inode/directory;application/x-gnome-saved-search;
      Actions=open-home;open-computer;open-trash;
    '';

    ".local/share/applications/nm-connection-editor.desktop".text =
    ''
      [Desktop Entry]
      Name=Advanced Network Configuration
      Comment=Manage and change your network connection settings
      Icon=${pkgs.networkmanagerapplet}/share/icons/hicolor/scalable/apps/nm-device-wired.svg
      Exec=${pkgs.networkmanagerapplet}/bin/nm-connection-editor
      Terminal=false
      StartupNotify=true
      Type=Application
      Categories=GNOME;GTK;Settings;X-GNOME-NetworkSettings;X-GNOME-Utilities;
    '';

    # Reference: https://www.reddit.com/r/NixOS/comments/1aszsj6/vmware_doesnt_follow_gtk_theme_in_hyprland/
    ".local/share/applications/vmware-workstation.desktop".text =
    ''
      [Desktop Entry]
      Encoding=UTF-8
      Name=VMware Workstation
      Comment=Run and manage virtual machines
      Exec=env GTK_THEME=Adwaita-dark ${pkgs.vmware-workstation}/bin/vmware %U
      Terminal=false
      Type=Application
      Icon=vmware-workstation
      StartupNotify=true
      Categories=System;
      MimeType=application/x-vmware-vm;application/x-vmware-team;application/x-vmware-enc-vm;x-scheme-handler/vmrc;
    '';
  };

  xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  dconf.settings = {
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    "org/nemo/preferences" = {
      show-hidden-files = true;
      default-folder-viewer = "list-view";
    };

    "org/nemo/list-view" = {
      default-visible-columns = [
        "name"
        "size"
        "type"
        "date_modified"
        "group"
        "owner"
        "permissions"
      ];
    };

    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
    };

    "org/nemo/preferences/menu-config" = {
      background-menu-open-in-terminal = false;
      background-menu-open-as-root = false;
      background-menu-show-hidden-files = false;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
