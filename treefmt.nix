{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs.stylua.enable = true;
  programs.nixfmt.enable = true;
  programs.yamlfmt.enable = true;
  #programs.shellcheck.enable = true;
  programs.toml-sort.enable = true;
  programs.mdformat.enable = true;
}
