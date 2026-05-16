{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    exegol.enable = lib.mkEnableOption "enables exegol";
  };

  config = lib.mkIf config.exegol.enable {
    # Exegol wrapper need the "my-resources" folder to have wider permissions
    home-manager.users.lapinou.home.file = {
      "/.exegol/HomeManagerInit_my-resources_setup" = {
        source = ./my-resources/setup;
        onChange = ''
          rm -rf ~/.exegol/my-resources/setup
          cp -L -r ~/.exegol/HomeManagerInit_my-resources_setup ~/.exegol/my-resources/setup
          chmod -R 777 ~/.exegol/my-resources/setup
        '';
      };
    };

    home-manager.users.lapinou.home.file = {
      "/.exegol/HomeManagerInit_my-resources_bin" = {
        source = ./my-resources/bin;
        onChange = ''
          rm -rf ~/.exegol/my-resources/bin
          cp -L -r ~/.exegol/HomeManagerInit_my-resources_bin ~/.exegol/my-resources/bin
          chmod -R 777 ~/.exegol/my-resources/bin
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      xorg.xhost
      exegol
    ];
  };
}
