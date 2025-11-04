{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nemo.enable = lib.mkEnableOption "enables nemo";
  };

  config = lib.mkIf config.nemo.enable {
    # Nemo folder bookmarks
    home-manager.users.lapinou.home.file = {
      ".config/gtk-3.0/bookmarks" = {
        text = ''
          file:///etc/nixos/ nixos
          file:///home/lapinou/.exegol/workspaces/ Exegol workspaces
          file:///home/lapinou/.exegol/ .exegol
          file:///mount/shared/ shared
          file:///etc/nixos/ nixos2
        '';
      };
    };

    home-manager.users.lapinou.home.file = {
      ".local/share/applications/nemo.desktop" = {
        text = ''
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
      };
    };

    home-manager.users.lapinou.dconf.settings = {
      "org/nemo/preferences" = {
        show-hidden-files = true;
        default-folder-viewer = "list-view";
        swap-trash-delete = true;
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

      "org/nemo/preferences/menu-config" = {
        background-menu-open-in-terminal = false;
        background-menu-open-as-root = false;
        background-menu-show-hidden-files = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      # Both seems necessary for some reason
      # Set default applications
      "org/cinnamon/desktop/default-applications/terminal" = {
        exec = "kitty";
      };
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
      };
    };

    environment.systemPackages = with pkgs; [
      nemo
    ];
  };
}
