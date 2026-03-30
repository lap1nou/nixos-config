WALLPAPERS_PATH="/etc/nixos/nixosModules/awesomewm/awesome/themes/wallpapers/"
CURRENT_WALLPAPER_PATH="/etc/nixos/nixosModules/awesomewm/awesome/themes/wallpaper.jpg"
SELECTED_WALLPAPER=$(find $WALLPAPERS_PATH -type f | vicinae dmenu)

if [[ ! -z "${SELECTED_WALLPAPER}" ]]; then
    sudo rm $CURRENT_WALLPAPER_PATH
    cd $WALLPAPERS_PATH/../
    sudo ln -s wallpapers/$(basename $SELECTED_WALLPAPER) $(basename $CURRENT_WALLPAPER_PATH)
fi
