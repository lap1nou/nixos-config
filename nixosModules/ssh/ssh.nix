{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    ssh.enable = lib.mkEnableOption "enables ssh";
  };

  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      startAgent = true;

      # Remember SSH passphrase for Github / Gitlab
      extraConfig = ''
        Host gitlab.com
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_rsa_gitlab

        Host github.com
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_rsa_github
      '';
    };
  };
}
