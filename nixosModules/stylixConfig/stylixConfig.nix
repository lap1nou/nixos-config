{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    stylixConfig.enable = lib.mkEnableOption "enables stylixConfig";
  };

  config = lib.mkIf config.stylixConfig.enable {
    stylix = {
      enable = true;
      image = self.outPath + "/nixosModules/awesomewm/awesome/themes/1/wallpaper.jpg";
      polarity = "dark";
      targets.grub.useImage = true;
    };
  };
}
