{
  osConfig,
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.zsh.enable = lib.mkEnableOption "enables zsh";
  };

  config = lib.mkIf config.homeManagerModules.zsh.enable {
    programs.zsh = {
      # https://nixos.wiki/wiki/Zsh
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "agnoster";
      };

      shellAliases = {
        cat = "bat -p -P";
        pcat = "bat";
        l = "eza --icons=always -algh";
        ll = "eza --icons=always -algh";
        ls = "eza --icons=always -algh";
        xclip = "xclip -i -sel p -f | xclip -i -sel c";
        update = "sudo nixos-rebuild switch --flake '/etc/nixos#${osConfig.variables.host}'";
        edit-config = "sudo code --no-sandbox --user-data-dir /root /etc/nixos/";
        nix-shell = "nix-shell --extra-experimental-features flakes --run zsh";
        change-theme = "change-wallpaper; sudo nixos-rebuild switch --flake '/etc/nixos#${osConfig.variables.host}'; echo 'awesome.restart()' | awesome-client";
      };
    };
  };
}
