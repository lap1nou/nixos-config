{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.homeManager.enable = lib.mkEnableOption "enables hm";
  };

  config = lib.mkIf config.homeManagerModules.homeManager.enable {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    home.username = lib.mkForce "lapinou";
    home.homeDirectory = lib.mkForce "/home/lapinou";

    programs.home-manager.enable = true;
  };
}
