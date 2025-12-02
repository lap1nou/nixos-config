{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.git.enable = lib.mkEnableOption "enables git";
  };

  config = lib.mkIf config.homeManagerModules.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.email = "lapinousexy@gmail.com";
        user.name = "lap1nou";
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_rsa_github.pub";
      };
      signing.signByDefault = true;
    };
  };
}
