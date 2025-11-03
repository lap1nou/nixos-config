{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    optimization.enable = lib.mkEnableOption "enables optimization";
  };

  config = lib.mkIf config.optimization.enable {
    # Store "/tmp" folder in RAM
    boot.tmp.useTmpfs = true;

    # https://nixos.wiki/wiki/Storage_optimization
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nix.optimise.automatic = true;

    documentation.enable = true;
    documentation.man.enable = true;
    documentation.doc.enable = false;
    documentation.info.enable = false;
    documentation.dev.enable = false;

    # Enable compression on the RAM swap file
    zramSwap.enable = true;

    # Clean folders older than 30D in the ".cache" folder of users
    systemd.user.tmpfiles.rules = [ "e %C - - - ABCM:30d -" ]; # Type Path Mode User Group Age Argument…
    services.upower.enable = true;

    # Remove default packages (perl, rsync, strace)
    environment.defaultPackages = [];
  };
}
