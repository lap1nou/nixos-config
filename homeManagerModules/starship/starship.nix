{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.starship.enable = lib.mkEnableOption "enables starship";
  };

  config = lib.mkIf config.homeManagerModules.starship.enable {
    programs.starship = {
      enable = true;
      #settings = builtins.fromTOML (builtins.readFile ./pkgs/starship/starship.toml);
      settings = builtins.fromTOML (''
        # Source: https://github.com/theRubberDuckiee/dev-environment-files/blob/main/starship.toml
        format = """\
        [](#${config.stylix.generated.palette.base02})\
        $status\
        $os\
        $env_var\
        $directory\
        [](fg:#${config.stylix.generated.palette.base01} bg:#${config.stylix.generated.palette.base03})\
        $nix_shell\
        $mise\
        [](fg:#${config.stylix.generated.palette.base03} bg:#${config.stylix.generated.palette.base09})\
        $git_branch\
        $git_status\
        $git_metrics\
        [](fg:#${config.stylix.generated.palette.base09} bg:none)
        [ └>](bold green) 
        """

        [status]
        disabled = false
        style = "fg:bold red bg:#${config.stylix.generated.palette.base02}"
        format = '[✗ ]($style)'

        [os]
        style = "bg:#${config.stylix.generated.palette.base02}"
        disabled = false

        [directory]
        format = "[  $path ]($style)"
        style = "fg:#${config.stylix.generated.palette.base05} bg:#${config.stylix.generated.palette.base01}"
        truncation_length = 0

        [nix_shell]
        style = "bg:#${config.stylix.generated.palette.base03}"
        symbol = '❄️'
        format = '[[ $symbol nix-shell ](bg:#${config.stylix.generated.palette.base03} fg:#${config.stylix.generated.palette.base00})]($style)'

        [git_branch]
        format = '[ $symbol$branch(:$remote_branch) ]($style)'
        symbol = "  "
        style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"

        [git_status]
        format = '[$all_status]($style)'
        style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"

        [git_metrics]
        format = "([+$added]($added_style))[]($added_style)"
        added_style = "fg:#${config.stylix.generated.palette.base00} bg:#${config.stylix.generated.palette.base09}"
        deleted_style = "fg:bright-red bg:235"
        disabled = false

        [mise]
        disabled = false
        symbol = 'mise'
        healthy_symbol = '✓'
        unhealthy_symbol = '✗'
        format = '[[ $health $symbol ](bg:#${config.stylix.generated.palette.base03} fg:#${config.stylix.generated.palette.base00})]($style)'

        [character]
        style = "bg:#${config.stylix.generated.palette.base05}"
        success_symbol = ""
        error_symbol = "[✗](#${config.stylix.generated.palette.base05})"
      '');
    };
  };
}
