WALLPAPERS_PATH="/etc/nixos/pkgs/awesome/themes/1/wallpapers/"
CURRENT_WALLPAPER_PATH="/etc/nixos/pkgs/awesome/themes/1/wallpaper.jpg"
SELECTED_WALLPAPER=$(find $WALLPAPERS_PATH -type f | fzf --preview="chafa -s 50x50 {}")

if [[ ! -z "${SELECTED_WALLPAPER}" ]]; then
    rm $CURRENT_WALLPAPER_PATH
    cd $WALLPAPERS_PATH/../
    ln -s wallpapers/$(basename $SELECTED_WALLPAPER) $(basename $CURRENT_WALLPAPER_PATH)
fi