{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.vscode.enable = lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.homeManagerModules.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions =
        with pkgs.vscode-extensions;
        [
          ms-azuretools.vscode-docker
        ];
    };
  };
}
