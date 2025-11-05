{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.atuin.enable = lib.mkEnableOption "enables atuin";
  };

  config = lib.mkIf config.homeManagerModules.atuin.enable {
    programs.atuin = {
        enable = true;
        settings = {
            enter_accept = false;
        };
    };
  };
}
