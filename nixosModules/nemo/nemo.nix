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
          Exec=nemo
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
        background-menu-open-in-terminal = true;
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

    xdg.mime.defaultApplications = {
      "application/pdf" = "firefox.desktop";

      # Video
      "video/mp2t" = "vlc.desktop";
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
      "video/x-flv" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";

      # Image
      "image/svg+xml" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/webp" = "feh.desktop";
      "image/jpg" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "image/bmp" = "feh.desktop";
      "image/gif" = "feh.desktop";

      # Archive
      "application/zip" = "peazip.desktop";

      # Text
      "text/csv" = "nano.desktop";
      "text/plain" = "nano.desktop";
      "text/css" = "nano.desktop";
      "text/html" = "nano.desktop";
      "text/markdown" = "nano.desktop";
      "text/javascript" = "nano.desktop";
      "text/tab-separated-values" = "nano.desktop";
      "text/x-java-source" = "nano.desktop";
      "text/x-python" = "nano.desktop";
      "text/x-c" = "nano.desktop";
      "application/xml" = "nano.desktop";
      "application/yaml" = "nano.desktop";
      "application/json" = "nano.desktop";
    };

    environment.systemPackages = with pkgs; [
      nemo-with-extensions
    ];
  };
}
