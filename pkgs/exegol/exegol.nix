{ lib, pkgs, ... }:
pkgs.python3Packages.buildPythonPackage rec {
  name = "exegol";
  version = "4.3.9";

  src = pkgs.fetchgit {
    url = "https://github.com/ThePorgs/Exegol.git";
    rev = "040a17080471cb7b7176817e481fd7d581cfaed0";
    sha256 = "sha256-NwPMiWTdXsTUTog1fSgcdt7L6C+29dviFZ/wDKFxlrg=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pkgs.python3Packages.docker
    pkgs.python3Packages.requests
    pkgs.python3Packages.rich
    pkgs.python3Packages.pyyaml
    pkgs.python3Packages.gitpython
    pkgs.python3Packages.argcomplete
  ];

  nativeBuildInputs = [ pkgs.installShellFiles pkgs.python312Packages.argcomplete ];

  postInstall = ''
    installShellCompletion --cmd exegol \
      --bash <(register-python-argcomplete exegol --shell bash) \
      --zsh <(register-python-argcomplete exegol --shell zsh) \
      --fish <(register-python-argcomplete exegol --shell fish)
  '';

}
