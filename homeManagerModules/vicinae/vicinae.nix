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
        theme.name = "stylixManual";
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

      # Reference: https://github.com/justDeeevin/nix-config
      themes.stylixManual = {
        meta = {
          version = 1;
          name = "Manual Stylix";
          description = "Workaround since Stylix for Vicinae is not working at the moment.";
          variant = "dark";
        };

        colors = let colors = (config.stylix.base16.mkSchemeAttrs config.stylix.base16Scheme).withHashtag; in {
          core = {
            background = colors.base00;
            foreground = colors.base06;
            border = colors.base03;
            accent = colors.base02;
            accent_foreground = colors.base06;
          };
        };
      };
    };

    # https://github.com/nix-community/home-manager/issues/8151
    systemd.user.services.vicinae.Service.Environment = [
      # "/run/wrappers/bin/" must be first for Wireshark to work correctly
      "PATH=/run/wrappers/bin/:/run/current-system/sw/bin:/home/lapinou/.local/bin/:/home/lapinou/.nix-profile/bin/"
    ];
  };
}
