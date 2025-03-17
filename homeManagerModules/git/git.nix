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
      userEmail = "lapinousexy@gmail.com";
      userName = "lap1nou";
      signing.signByDefault = true;

      extraConfig = {
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_rsa_github.pub";
      };
    };
  };
}
