{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    hardening.enable = lib.mkEnableOption "enables hardening";
  };

  config = lib.mkIf config.hardening.enable {
    networking = {
      firewall.enable = true;
      enableIPv6 = false;
    };

    security.sudo.execWheelOnly = true;

    # Logging
    # Disabled for now because the NixOS audit module is still in development
    # https://github.com/NixOS/nixpkgs/issues/44059
    #security.auditd.enable = true;
    #security.audit.enable = true;
    # Reference: https://github.com/Neo23x0/auditd/blob/master/audit.rules
    #security.audit.rules = [
    #  "-w /etc/passwd -p wa -k password_changes"
    #  "-w /etc/shadow -p rwa -k password2_changes"
    #  "-a always,exit -F perm=x -F auid!=-1 -F path=${pkgs.kmod}/bin/insmod -k modules"
    #];

    #fileSystems."/".options = [ "noexec" ];
    #fileSystems."/etc/nixos".options = [ "noexec" ];
    #fileSystems."/srv".options = [ "noexec" ];
    #fileSystems."/var/log".options = [ "noexec" ];
  };
}
