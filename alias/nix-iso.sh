git clone https://github.com/lap1nou/nixos-config.git /tmp/nixos-config
touch /tmp/nixos-config/.htb_env /tmp/nixos-config/.phone-wifi
cd /tmp/nixos-config/ && git add -f /tmp/nixos-config/.htb_env /tmp/nixos-config/.phone-wifi
sudo nixos-generate -f iso --flake /tmp/nixos-config/ -o out.iso
rm -rf /tmp/nixos-config
