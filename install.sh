# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

read -s -p "Enter the LUKS password:" password
echo -n "$password" > /tmp/secret.key

# Apply Disko partitioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./disko-config.nix

# Copy and install NixOS config
nixos-generate-config --root /mnt
cp -R ../nixos-config/. /mnt/etc/nixos
touch /mnt/etc/nixos/.htb_env
cd /mnt/etc/nixos/ && git add -f .htb_env

nixos-install --flake /mnt/etc/nixos/.#pentest
