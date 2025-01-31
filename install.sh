# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Apply Disko partitioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./nixos-config/disko-config.nix

# Copy and install NixOS config
nixos-generate-config --no-filesystems --root /mnt
cp -R ./nixos-config/. /mnt/etc/nixos
touch /mnt/etc/nixos/.htb_env
cd /mnt/etc/nixos/ && git add -f .htb_env

nixos-install --flake /mnt/etc/nixos/.#pentest
