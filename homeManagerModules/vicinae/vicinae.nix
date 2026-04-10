{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.vicinae.enable = lib.mkEnableOption "enables vicinae";
  };

  config = lib.mkIf config.homeManagerModules.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      systemd.autoStart = true;

      settings = {
        closeOnFocusLoss = true;
        theme.name = "stylix";

        #providers = {
        #  "@lap1nou/vicinae-extension-exegol-0".preferences = {
        #    custom = "test";
        #  };
        #};
      };

      # Reference: https://github.com/scottmckendry/nix
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "exegol";
          src = pkgs.fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "1991d5454eb8bd5d265fd1daf006701656036a8b";
            sha256 = "sha256-vkcO1qA11FmBg4JXD5VzpcZ7yZmczuBEzSYj112N7+o=";
          } + "/extensions/exegol";
        })
      ];
    };

    # https://github.com/nix-community/home-manager/issues/8151
    systemd.user.services.vicinae.Service.Environment = [
      # "/run/wrappers/bin/" must be first for Wireshark to work correctly
      "PATH=/run/wrappers/bin/:/run/current-system/sw/bin:/home/lapinou/.local/bin/:/home/lapinou/.nix-profile/bin/"
    ];
  };
}
