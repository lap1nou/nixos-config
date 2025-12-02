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
          pkief.material-icon-theme
          #rust-lang.rust-analyzer
          charliermarsh.ruff
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "sarif-viewer";
            publisher = "MS-SarifVSCode";
            version = "3.4.2";
            sha256 = "sha256-HDuDelX9kCK58Re8aTlKP+EJi4fSm5lejXsvxlMXRxM=";
          }
          {
            name = "devbox";
            publisher = "jetpack-io";
            version = "0.1.6";
            sha256 = "sha256-cPlMZzF3UNVJCz16TNPoiGknukEWXNNXnjZVMyp/Dz8=";
          }
        ];
    };
  };
}
