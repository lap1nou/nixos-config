WALLPAPERS_PATH="/etc/nixos/pkgs/awesome/themes/1/wallpapers/"
CURRENT_WALLPAPER_PATH="/etc/nixos/pkgs/awesome/themes/1/wallpaper.jpg"
#SELECTED_WALLPAPER=$(find $WALLPAPERS_PATH -type f | fzf --preview="chafa -s 50x50 {}")
FZF_COLS=$(($(tput cols) / 2 - 4))
FZF_LINES=$(tput lines)
FZF_PREVIEW_SIZE=${FZF_COLS}x${FZF_LINES}@${FZF_COLS}x0
SELECTED_WALLPAPER=$(find $WALLPAPERS_PATH -type f | fzf --preview="kitty icat --clear --transfer-mod=memory --stdin=no --place=${FZF_PREVIEW_SIZE} {}")
if [[ ! -z "${SELECTED_WALLPAPER}" ]]; then
    sudo rm $CURRENT_WALLPAPER_PATH
    cd $WALLPAPERS_PATH/../
    sudo ln -s wallpapers/$(basename $SELECTED_WALLPAPER) $(basename $CURRENT_WALLPAPER_PATH)
fi