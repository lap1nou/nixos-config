{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    phone_wifi.enable = lib.mkEnableOption "enables phone Wifi";
  };

  config = lib.mkIf config.phone_wifi.enable {
    networking = {
    hostName = "pentest";
    networkmanager = {
      enable = true;
      ensureProfiles.profiles = {
        phone-wifi = {
          connection = {
            id = "Phone WiFi";
            type = "wifi";
          };

          wifi = {
            mode = "infrastructure";
            ssid = "WE-C423";
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = builtins.readFile (self.outPath + "/secrets/.phone_wifi");
          };
        };
      };
    };
  };
  };
}
