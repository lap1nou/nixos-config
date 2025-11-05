{
  config,
  pkgs,
  fetchFromGitHub,
  lib,
  ...
}:

{
  imports = [ ../../homeManagerModules/default.nix ];

  homeManagerModules.homeManager.enable = true;
  homeManagerModules.atuin.enable = true;
  homeManagerModules.starship.enable = true;
  homeManagerModules.zsh.enable = true;
  homeManagerModules.rofi.enable = true;
  homeManagerModules.git.enable = true;
  homeManagerModules.vscode.enable = true;
  homeManagerModules.bat.enable = true;
  homeManagerModules.stylix.enable = true;
  homeManagerModules.kitty.enable = true;

  nixpkgs.config.allowUnfree = true;

  xsession = {
    windowManager.awesome.enable = true;
  };

  home.file = {
    ".local/share/applications/org.flameshot.Flameshot.desktop".text = ''
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

    ".local/share/applications/nm-connection-editor.desktop".text = ''
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
  };
}
