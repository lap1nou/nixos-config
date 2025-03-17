{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
  rdm = pkgs.stdenv.mkDerivation rec {
    name = "rdm";
    version = "2024.3.2.13";

    src = pkgs.fetchurl {
      url = "https://cdn.devolutions.net/download/Linux/RDM/${version}/RemoteDesktopManager_${version}_amd64.deb";
      sha256 = "sha256-WOivRK2MaPDr3258KK80dW3KuCACuzu2rLG49kta/t0=";
    };

    nativeBuildInputs = [
      pkgs.dpkg
      pkgs.makeWrapper
      pkgs.autoPatchelfHook
    ];

    dontConfigure = true;
    dontBuild = true;

    buildInputs = [
      pkgs.xorg.libXext
      pkgs.libxcrypt-legacy
      pkgs.xorg.libSM
      pkgs.cups
      pkgs.vte
      pkgs.krb5
      pkgs.lttng-ust_2_12
      pkgs.webkitgtk
      pkgs.libsoup_3
      pkgs.stdenv.cc.cc.lib
      pkgs.alsa-lib
      pkgs.webkitgtk_4_1
    ];

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      mkdir -p $out/usr/bin

      ln -s $out/bin/remotedesktopmanager $out/usr/bin/remotedesktopmanager
    '';

    postFixup = ''
      echo "exec $out/usr/lib/devolutions/RemoteDesktopManager/RemoteDesktopManager \$@" > $out/bin/remotedesktopmanager
      wrapProgram $out/usr/lib/devolutions/RemoteDesktopManager/RemoteDesktopManager --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          pkgs.icu
          pkgs.gtk3-x11
          pkgs.openssl
        ]
      };
    '';
  };
in
{
  options = {
    rdm.enable = lib.mkEnableOption "enables rdm";
  };

  config = lib.mkIf config.rdm.enable {
    home-manager.users.lapinou.home.packages = [
      rdm
    ];
  };
}
