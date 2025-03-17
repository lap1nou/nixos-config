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
    #home-manager.users.lapinou.home.file = {
    #    ".exegol/config.yml" = {
    #        source = ./config.yml;
    #    };
    #};

    home-manager.users.lapinou.home.file = {
      "/.exegol/HomeManagerInit_my-resources" = {
        source = ./my-resources;
        onChange = ''
          rm -rf ~/.exegol/my-resources
          cp -L -r ~/.exegol/HomeManagerInit_my-resources ~/.exegol/my-resources
          chmod -R 777 ~/.exegol/my-resources
        '';
      };
    };

    #Exegol
    #"${home-manager.users.lapinou.home.homeDirectory}/.exegol/config.yml".source = ./pkgs/exegol/config.yml;
    # Exegol wrapper need the "my-resources" folder to have wider permissions
    # Dirty workaround: https://github.com/nix-community/home-manager/issues/3090#issuecomment-2010891733
    #"${home-manager.users.lapinou.home.homeDirectory}/.exegol/HomeManagerInit_my-resources" = {
    #  source = ./my-resources;
    #  onChange = ''
    #    rm -rf ${home-manager.users.lapinou.home.homeDirectory}/.exegol/my-resources
    #    cp -L -r ${home-manager.users.lapinou.home.homeDirectory}/.exegol/HomeManagerInit_my-resources ${config.home.homeDirectory}/.exegol/my-resources
    #    chmod -R 777 ${home-manager.users.lapinou.home.homeDirectory}/.exegol/my-resources
    #  '';
    #};

    environment.systemPackages = with pkgs; [
      xorg.xhost
      exegol
    ];
  };
}
