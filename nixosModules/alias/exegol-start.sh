# This script show the list of Exegol containers with 'fzf' and then start the selected container
container_name=$(docker ps --all --format '{{.Names}}' --filter "name=^exegol-" | cut -d '-' -f 2 | fzf --prompt="Choose an Exegol container to start:" --header="Container name")
exegol start "$container_name"