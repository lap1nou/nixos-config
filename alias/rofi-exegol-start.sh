# This script show the list of Exegol containers with 'rofi' and then start the selected container
container_name=$(docker ps --all --format '{{.Names}}' --filter "name=^exegol-" | cut -d '-' -f 2 | rofi -dmenu -p " 󰣙 Choose an Exegol container:" -c ~/.config/rofi/config.rasi)
if [[ ! -z "$container_name" ]]; then
    #alacritty -e exegol start "$container_name"
    kitty exegol start "$container_name"
fi