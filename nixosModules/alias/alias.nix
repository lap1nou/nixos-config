{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    alias.enable = lib.mkEnableOption "enables alias";
  };

  config = lib.mkIf config.alias.enable {
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "htb-new" (builtins.readFile ./htb-new.sh))
      (writeShellScriptBin "pentest-new" (builtins.readFile ./pentest-new.sh))
      (writeShellScriptBin "exegol-start" (builtins.readFile ./exegol-start.sh))
      (writeShellScriptBin "rofi-exegol-start" (builtins.readFile ./rofi-exegol-start.sh))
      (writeShellScriptBin "change-wallpaper" (builtins.readFile ./change-wallpaper.sh))
      (writeShellScriptBin "nix-install" (builtins.readFile ./nix-install.sh))
      (writeShellScriptBin "nix-iso" (builtins.readFile ./nix-iso.sh))
      (writeShellScriptBin "nix-clean" (builtins.readFile ./nix-clean.sh))
    ];
  };
}
