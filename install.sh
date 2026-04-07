#!/usr/bin/env bash
# install.sh — restore db's Arch Linux setup from this dotfiles repo
# Run from the repo root: bash install.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "==> Dotfiles dir: $DOTFILES_DIR"
echo "==> Target home:  $HOME_DIR"
echo ""

###############################################################################
# 1. Install packages
###############################################################################
if command -v pacman &>/dev/null; then
    read -rp "Install packages from packages.txt? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        echo "==> Installing AUR helper (yay)..."
        if ! command -v yay &>/dev/null; then
            sudo pacman -S --needed git base-devel
            git clone https://aur.archlinux.org/yay.git /tmp/yay-install
            (cd /tmp/yay-install && makepkg -si --noconfirm)
            rm -rf /tmp/yay-install
        fi
        echo "==> Installing packages..."
        yay -S --needed - < "$DOTFILES_DIR/packages.txt"
    fi
else
    echo "[skip] pacman not found — skipping package install"
fi

###############################################################################
# 2. Copy .config directories
###############################################################################
echo ""
echo "==> Copying .config directories..."
mkdir -p "$HOME_DIR/.config"
rsync -av --exclude='ags/node_modules' "$DOTFILES_DIR/.config/" "$HOME_DIR/.config/"

###############################################################################
# 3. Install ags dependencies
###############################################################################
if [ -f "$HOME_DIR/.config/ags/package.json" ] && command -v npm &>/dev/null; then
    echo ""
    echo "==> Installing ags npm dependencies..."
    (cd "$HOME_DIR/.config/ags" && npm install)
fi

###############################################################################
# 4. Copy bin scripts
###############################################################################
echo ""
echo "==> Installing bin scripts to ~/bin/..."
mkdir -p "$HOME_DIR/bin"
cp -v "$DOTFILES_DIR/bin/"* "$HOME_DIR/bin/"
chmod +x "$HOME_DIR/bin/"*

###############################################################################
# 5. Copy .bashrc
###############################################################################
echo ""
if [ -f "$HOME_DIR/.bashrc" ]; then
    read -rp ".bashrc already exists — overwrite? [y/N] " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        cp -v "$DOTFILES_DIR/.bashrc" "$HOME_DIR/.bashrc"
    else
        echo "[skip] .bashrc not changed"
    fi
else
    cp -v "$DOTFILES_DIR/.bashrc" "$HOME_DIR/.bashrc"
fi

###############################################################################
# 6. Copy wallpapers
###############################################################################
echo ""
read -rp "Copy wallpapers to ~/Pictures/wallpapers/? [y/N] " yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME_DIR/Pictures/wallpapers"
    cp -v "$DOTFILES_DIR/wallpapers/"* "$HOME_DIR/Pictures/wallpapers/"
fi

###############################################################################
# Done
###############################################################################
echo ""
echo "==> Done! You may need to:"
echo "    - Log out and back in (or reboot) for everything to take effect"
echo "    - Run: dbtheme <name>  (to apply a theme)"
echo "    - Run: ags run --gtk 3 ~/.config/ags/app.ts &  (to start the bar)"
echo ""
echo "Available themes: db, forest, goretex, lain, omarchy, arizona, b,"
echo "                  bazzerk, cathedral, cumulonimbus, oilpaint, paint,"
echo "                  windows, zenin"
