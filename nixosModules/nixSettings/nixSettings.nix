{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    nixSettings.enable = lib.mkEnableOption "enables nixSettings";
  };

  config = lib.mkIf config.nixSettings.enable {
    nixpkgs.config.allowUnfree = true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };
}
