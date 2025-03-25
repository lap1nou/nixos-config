git clone https://github.com/lap1nou/nixos-config.git /tmp/nixos-config
#sudo nixos-generate -f iso --flake /tmp/nixos-config/ -o out.iso
sudo nix build '/tmp/nixos-config/#iso'
rm -rf /tmp/nixos-config
