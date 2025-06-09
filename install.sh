#!/bin/bash

PACMAN_PKGS=(ttf-nerd-fonts-symbols neovim brightnessctl noto-fonts-emoji python-requests less base-devel github-cli rsync ncdu qt5-wayland qt6-wayland qt5ct kvantum kvantum-qt5 nwg-look hyprland net-tools alacritty python3 python-pip btop fastfetch waybar rofi cliphist wl-clipboard networkmanager nm-connection-editor swaync swaybg swww hyprpaper hyprlock pavucontrol font-manager ttf-font-awesome ttf-nerd-fonts-symbols aria2 unrar file-roller thunar tumbler gvfs git mousepad)
AUR_PKGS=(apple-fonts ttf-mac-fonts cava wlogout python-pywal16 librewolf-bin nwg-look mpvpaper ffmpegthumbnailer hyprshot qt6ct-kde)

install_aur_helper() {
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
}

install_paru() {
    if ! sudo pacman -S --needed --noconfirm git base-devel; then
        echo "[!] Failed to install dependencies" >&2
        return 1
    fi
    echo "→ Cloning paru repository..."
    if ! git clone https://aur.archlinux.org/paru.git /tmp/paru; then
        echo "[!] Failed to clone paru repository" >&2
        return 1
    fi
    echo "→ Building and installing paru..."
    (cd /tmp/paru && makepkg -si --noconfirm) || {
        echo "[!] Failed to build/install paru" >&2
        return 1
    }
    if command -v paru &>/dev/null; then
        echo "[✔] Paru successfully installed"
        return 0
    else
        echo "[!] Paru installation failed" >&2
        return 1
    fi
}

install_packages() {
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
  yay -S --needed --noconfirm "${AUR_PKGS[@]}"
}

fix_xdg_portal_hypr() {
    sudo pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk || {
        echo "[!] Не удалось установить пакеты"
        return 1
    }
    sudo mkdir -p /etc/xdg/xdg-desktop-portal
    echo -e "[preferred]\ndefault=hyprland" | sudo tee /etc/xdg/xdg-desktop-portal/portals.conf > /dev/null
    systemctl --user daemon-reexec
    systemctl --user restart xdg-desktop-portal.service
    systemctl --user restart xdg-desktop-portal-hyprland.service
    pkill -f xdg-desktop-portal || true
    pkill -f xdg-desktop-portal-hyprland || true
    if busctl --user introspect org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings &>/dev/null; then
        echo "[✔] Done!"
    else
        echo "[!] Interface not responding, Try Reboot."
        return 2
    fi
}

install_ohmybash() {
  if git clone --depth=1 https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash; then
    echo "[✔] OhMyBash Cloned!"
  else
    echo "[!] OhMyBash Not Cloned!"
    return 1
  fi
}

setup_language() {
    echo "→ Uncommenting ru_RU.UTF-8 in /etc/locale.gen"
    sudo sed -i 's/^#\?ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen || {
        echo "[!] Failed to modify /etc/locale.gen"
        return 1
    }
    echo "→ Generating locale"
    sudo locale-gen || {
        echo "[!] Failed to generate locales"
        return 1
    }
    echo "→ Setting LANG variable in /etc/locale.conf"
    echo "LANG=ru_RU.UTF-8" | sudo tee /etc/locale.conf > /dev/null || {
        echo "[!] Failed to write to /etc/locale.conf"
        return 1
    }
    echo "[✔] Locale ru_RU.UTF-8 successfully configured"
}

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
  install_aur_helper
  wait
  install_paru
  wait
  install_packages
  wait
  fix_xdg_portal_hypr
  wait
  install_ohmybash
  wait
  setup_language
  wait
  copy_configs
  wait
  hyprctl reload
  echo "Installed!"
}

main "$@"
