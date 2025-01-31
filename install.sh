# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Copy and install NixOS config
nixos-generate-config --no-filesystems --root /mnt
cp -R ../nixos-config/. /mnt/etc/nixos
touch /mnt/etc/nixos/.htb_env
cd /mnt/etc/nixos/ && git add -f .htb_env

# Apply Disko partitioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko /mnt/etc/nixos/disko-config.nix

nixos-install --flake /mnt/etc/nixos/.#pentest
