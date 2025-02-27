function spin_task() {
    # The expression "${@:2}" take the argument starting from the second 
    gum spin --spinner dot --title "$1" --show-error -- "${@:2}"

    if [[ "$?" -eq 0 ]]; then
        echo '{{ Color "#62b851" "0" "" }} {{ "'$1'\n" }}' | gum format -t template
    else
        echo '{{ Color "#d63209" "0" "" }} {{ "'$1'\n" }}' | gum format -t template
        exit 1
    fi
}

NIXOS_CONFIG_DOWNLOAD_PATH="/tmp/nixos-config"
NIXOS_CONFIG_PATH="/mnt/etc/nixos"

# Check that the script is ran as root
if [[ $EUID -ne 0 ]]; then
    echo '{{ Color "#d63209" "0" "" }} {{ "This script need to be run as" }} {{ Color "#d63209" "0" "root\n" }}' | gum format -t template
    sudo "$0"
    exit 0
fi

# Check if there is enough RAM
RAM=$(free -g | awk '{print $2}' | head -n 2 | tail -n 1)

if [[ "$RAM" -le 10 ]]; then
    echo '{{ Color "#d63209" "0" "" }} {{ "Not enough RAM," }} {{ Color "#d63209" "0" "10 GB" }} {{ "are required minimum\n" }} ' | gum format -t template
    exit 1
fi

# Ask the user to choose one of the disk
SELECTED_DISK=$(lsblk -nd -o PATH,TYPE | awk '{if ($2 == "disk") print $1}' | gum choose --header="Select the disk you want to install NixOS on:" --cursor=" " --no-show-help)

if [[ -z "$SELECTED_DISK" ]]; then
    echo '{{ Color "#d63209" "0" "" }} {{ "Please select a disk\n" }}' | gum format -t template
    exit 1
fi

# Replace the selected disk in the "disko" config
echo '{{ Color "#62b851" "0" "" }} {{ "NixOS will be installed on" }} {{ Color "#62b851" "0" "'$SELECTED_DISK'\n" }}' | gum format -t template
sed -i "s|device = \".*\";|device = \"$SELECTED_DISK\";|g" "$NIXOS_CONFIG_DOWNLOAD_PATH/disko-config.nix"

while true; do
    LUKS_PASSWORD=$(gum input --no-show-help --placeholder="Enter the LUKS password..." --password)
    LUKS_PASSWORD_REPEAT=$(gum input --no-show-help --placeholder="Enter the LUKS password again..." --password)

    if [[ "$LUKS_PASSWORD" != "$LUKS_PASSWORD_REPEAT" ]]; then
        echo '{{ Color "#d63209" "0" "" }} {{ "Password are not the same, please try again.\n" }}' | gum format -t template
    else
        echo $LUKS_PASSWORD > /tmp/secret.key
        echo '{{ Color "#62b851" "0" "" }} {{ "Password matches !\n" }}' | gum format -t template
        break
    fi
done

spin_task "Installing home-manager..." nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
spin_task "Updating nix-channel..." nix-channel --update
git clone https://github.com/lap1nou/nixos-config.git "$NIXOS_CONFIG_DOWNLOAD_PATH/"
spin_task "Apply Disko partitioning..." nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko "$NIXOS_CONFIG_DOWNLOAD_PATH/disko-config.nix"

spin_task "Generating NixOS basic config..." nixos-generate-config --no-filesystems --root /mnt

cp -R "$NIXOS_CONFIG_DOWNLOAD_PATH/." "$NIXOS_CONFIG_PATH"
touch "$NIXOS_CONFIG_PATH/.htb_env" "$NIXOS_CONFIG_PATH/.phone-wifi"
cd "$NIXOS_CONFIG_PATH/" && git add -f .htb_env .phone-wifi

spin_task "Installing NixOS..." nixos-install --no-root-passwd --flake "$NIXOS_CONFIG_PATH/.#pentest"
