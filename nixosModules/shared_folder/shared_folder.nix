{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    shared_folder.enable = lib.mkEnableOption "enables shared_folder";
  };

  config = lib.mkIf config.shared_folder.enable {
    # Shared folder VMWare
    fileSystems."/mount/shared" = {
      device = ".host:/shared";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = [
        "umask=22"
        "uid=1000"
        "gid=100"
        "allow_other"
        "defaults"
        "auto_unmount"
      ];
    };
  };
}
