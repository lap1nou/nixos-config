# # Reference: https://github.com/hirano00o/dotfiles/blob/d633528e9791543f2e5217453a30642fb173ab2c/home-manager/packages/safe-chain/default.nix
{ lib, pkgs, config, ... }:
let safe-chain = pkgs.stdenv.mkDerivation rec {
  name = "safe-chain";
  version = "1.4.7";

  src = pkgs.fetchurl {
    url = "https://github.com/AikidoSec/safe-chain/releases/download/${version}/safe-chain-linux-x64";
    sha256 = "sha256-9mrQORygknHPzfxBanen9+jgI1Z31d81GiO57HbWplQ=";
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/safe-chain
    chmod +x $out/bin/safe-chain
  '';
};
in
{
  options = {
    safe-chain.enable = lib.mkEnableOption "enables safe-chain";
  };

  config = lib.mkIf config.safe-chain.enable {
    home-manager.users.lapinou.home.packages = [
      safe-chain
    ];
  };
}