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
        l = "eza --icons=always -algh";
        ll = "eza --icons=always -algh";
        ls = "eza --icons=always -algh";
        exegol = "/home/lapinou/.local/bin/exegol";
        xclip = "xclip -i -sel p -f | xclip -i -sel c";
        nix-update = "sudo nixos-rebuild switch --flake '/etc/nixos#${osConfig.variables.host}'";
        nix-edit-config = "sudo code --no-sandbox --user-data-dir /root /etc/nixos/";
        nix-shell = "nix-shell --extra-experimental-features flakes --run zsh";
        nix-change-theme = "change-wallpaper; sudo nixos-rebuild switch --flake '/etc/nixos#${osConfig.variables.host}'; echo 'awesome.restart()' | awesome-client";
        vmware-fix = "sudo pkill -f 'vmtoolsd'; vmware-user-suid-wrapper &; sudo systemctl restart vmware.service";
        fzf-if = ''
          SELECTION=$(ip --json a | jq -r ".[] | [.ifname, [(.addr_info[] | select(.family==\"inet\") | .local)]] | .[0] + \"|\" + (if (.[1] | length) > 0 then .[1][0] else \"\" end) + \"|\" + (if (.[1] | length) > 0 then .[0] + \" \\u001b[33m(\" + (.[1] | join(\", \")) + \")\\u001b[0m\" else \"\\u001b[2m\" + .[0] + \"\\u001b[0m\" end)" | fzf --ansi -d "|" --with-nth=3 | cut -d "|" -f1,2); [ -n "$SELECTION" ] && INTERFACE=${SELECTION%%|*} ATTACKER_IP=${SELECTION#*|}
        '';
      };

      initContent = ''
        if [[ -f ~/.safe-chain/scripts/init-posix.sh ]]; then
          source ~/.safe-chain/scripts/init-posix.sh
        fi

        [[ -s "${pkgs.grc}/etc/grc.zsh" ]] && source ${pkgs.grc}/etc/grc.zsh
      '';
    };
  };
}
