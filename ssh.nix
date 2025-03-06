{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:
{
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    (builtins.fetchurl {
      url = "https://github.com/lap1nou.keys";
      sha256 = "sha256:0prg6z4q5m813rk11xqdv18dwk4rdk6mwgxw0p0fam0h7nls0y25";
    })
  ];
}
