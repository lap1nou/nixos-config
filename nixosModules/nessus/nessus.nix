{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    nessus.enable = lib.mkEnableOption "enables nessus";
  };

  config = lib.mkIf config.nessus.enable {
    # Reference: https://discourse.nixos.org/t/pull-docker-image-for-later-use/52106/6
    systemd.services.docker-preload = {
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.virtualisation.docker.package ];
      script = ''
        docker load -i ${
          pkgs.dockerTools.pullImage {
            imageName = "tenable/nessus";
            imageDigest = "sha256:1aaf1a0a7ef760412386cdec56273bdc3ec73c48cf32aacb75d5fb8d6676c30a";
            sha256 = "8FF/Mfov3MWV1OG8ZXlALTa9R7UrEEFplKztrkp7nQk=";
            finalImageName = "nessus";
            finalImageTag = "10.8.3-ubuntu";
          }
        }
      '';
      serviceConfig = {
        RemainAfterExit = true;
        Type = "oneshot";
      };
    };
  };
}
