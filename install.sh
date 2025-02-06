# Check that the script is ran as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run it as root!"
    exit 1
fi

# Gather all available disks
DISKS=($(lsblk -nd -o NAME,TYPE | awk '{if ($2 == "disk") print $1}'))

for i in "${!DISKS[@]}"
do
    echo "$((i+1))) /dev/${DISKS[$i]}"
done

# Ask the user to choose one of the disk
while true; do
    read -p "Enter the disk you want to install NixOS on: " CHOICE
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && (( CHOICE >= 1 && CHOICE <= ${#DISKS[@]} )); then
        SELECTED_DISK="/dev/${DISKS[$((CHOICE-1))]}"
        break
    else
        echo "Invalid choice. Please enter a number between 1 and ${#DISKS[@]}"
    fi
done

# Replace the selected disk in the "disko" config
echo "NixOS will be installed on $SELECTED_DISK"
sed -i "s|DISK_NAME|$SELECTED_DISK|g" disko-config.nix

read -s -p "Enter the LUKS password:" password
echo -n "$password" > /tmp/secret.key

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Apply Disko partitioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./disko-config.nix

# Copy and install NixOS config
nixos-generate-config --no-filesystems --root /mnt
cp -R ../nixos-config/. /mnt/etc/nixos
touch /mnt/etc/nixos/.htb_env
cd /mnt/etc/nixos/ && git add -f .htb_env

nixos-install --flake /mnt/etc/nixos/.#pentest
