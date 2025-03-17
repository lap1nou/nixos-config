{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    wireguard.enable = lib.mkEnableOption "enables wireguard";
  };

  config = lib.mkIf config.wireguard.enable {
    networking.wireguard = {
      # Wireguard interface for Ludus lab
      enable = true;
      # Reference: https://alberand.com/nixos-wireguard-vpn.html
      interfaces = {
        wg0 = {
          # Determines the IP address and subnet of the client's end of the tunnel interface.
          ips = [ "198.51.100.2/32" ];
          listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

          privateKey = builtins.readFile (self.outPath + "./secrets/.wg_ludus.key");

          peers = [
            # For a client configuration, one peer entry for the server will suffice.

            {
              # Public key of the server (not a file path).
              publicKey = "Bd1iTeoQsdDUUFUmf0IVvEr7tQOkzuqMwxWfZMSy7B0=";

              # Forward all the traffic via VPN.
              allowedIPs = [
                "10.2.0.0/16"
                "198.51.100.1/32"
              ];

              # Set this to the server IP and port.
              endpoint = "192.168.100.76:51820";

              # Send keepalives every 25 seconds. Important to keep NAT tables alive.
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
