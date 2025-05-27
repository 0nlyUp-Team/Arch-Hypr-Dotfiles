#!/bin/bash

copy_configs() {
    local repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local src="$repo_dir/Dotfiles/main"
    local src2="$repo_dir/Dotfiles/home"
    local target="$HOME/.config"
    local target2="$HOME"
    [ ! -d "$src" ] && { echo "Error: Folder Not Found: $src"; exit 1; }
    [ ! -d "$src2" ] && { echo "Error: Folder Not Found: $src2"; exit 1; }
    rsync -avh "$src"/ "$target"/
    rsync -avh --exclude=".git" "$src2"/ "$target2"/
    find "$target" -type f -name "*.sh" -exec chmod +x {} \;
}

wait(){
    sleep 5
    clear
}

main() {
  copy_configs
  wait
  hyprctl reload
  echo "Installed!"
}
main "$@"
