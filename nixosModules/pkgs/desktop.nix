{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    desktop.enable = lib.mkEnableOption "enables desktop";
  };

  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = with pkgs; [
      #(catppuccin-sddm.override {
      #  flavor = "mocha";
      #  font = "Noto Sans";
      #  fontSize = "9";
      #  background = self.outPath + "/nixosModules/awesomewm/awesome/themes/1/wallpaper.jpg";
      #  loginBackground = true;
      #})
      spotify
      vlc
    ];

    programs.dconf.enable = true; # https://discourse.nixos.org/t/error-gdbus-error-org-freedesktop-dbus-error-serviceunknown-the-name-ca-desrt-dconf-was-not-provided-by-any-service-files/29111
  };
}
