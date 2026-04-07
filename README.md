# db's dotfiles

Arch Linux setup — Hyprland compositor with AGS bar, custom theming system, and scripts.

## Contents

```
dotfiles/
├── .config/
│   ├── ags/          — AGS bar (TypeScript widgets: workspaces, clock, sysinfo, focused client)
│   ├── btop/         — btop resource monitor + themes
│   ├── cava/         — audio visualizer config + shaders
│   ├── fastfetch/    — system info fetch config
│   ├── foot/         — foot terminal (colors managed by dbtheme)
│   ├── hypr/         — Hyprland config, hyprpaper, shaders
│   ├── ironbar/      — ironbar bar config (colors managed by dbtheme)
│   ├── kitty/        — kitty terminal config
│   ├── swaylock/     — lock screen config
│   ├── wofi/         — app launcher config
│   └── yay/          — yay AUR helper config
├── bin/
│   ├── dbackup       — encrypted local backup of configs to ~/db-backups/
│   ├── dbfloatall    — toggle all windows floating/tiled (Hyprland)
│   ├── dbshot        — area screenshot (grimblast → hyprshot → grim+slurp)
│   ├── dbtheme       — apply a full theme: wallpaper + terminal colors + bar colors
│   └── dbtogglebar   — toggle AGS bar on/off
├── wallpapers/       — 14 wallpapers, each with a matching dbtheme entry
├── .bashrc           — aliases, PATH, adaptive fastfetch
├── packages.txt      — explicit pacman package list (pacman -Qqe)
└── install.sh        — automated restore script
```

## Theming

All themes are applied with `dbtheme <name>`. Each theme sets:
- Wallpaper (via `swww`)
- Foot terminal colors
- Hyprland border colors
- Ironbar bar background/border
- AGS bar colors (`colors.css`)
- Peaclock clock colors

**Available themes:** `db` · `forest` · `goretex` · `lain` · `omarchy` · `arizona` · `b` · `bazzerk` · `cathedral` · `cumulonimbus` · `oilpaint` · `paint` · `windows` · `zenin`

## Fresh Install / Restore

```bash
git clone https://github.com/reesem23/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The script will (with prompts):
1. Install `yay` if missing, then install all packages from `packages.txt`
2. Sync `.config/` directories to `~/.config/`
3. Install ags npm dependencies
4. Copy `bin/` scripts to `~/bin/` and make them executable
5. Copy `.bashrc`
6. Copy wallpapers to `~/Pictures/wallpapers/`

## Key Packages

| Category | Package |
|---|---|
| Compositor | `hyprland` |
| Bar | `aylurs-gtk-shell` (AGS) |
| Terminal | `foot`, `kitty` |
| Wallpaper | `swww` |
| Launcher | `wofi` |
| Lock screen | `swaylock` |
| Audio vis | `cava` |
| AUR helper | `yay` |
| Screenshots | `grimblast` / `hyprshot` / `grim` + `slurp` |

## Scripts

| Script | Usage |
|---|---|
| `dbtheme <name>` | Apply a full color theme + wallpaper |
| `dbshot` | Area screenshot to clipboard + file |
| `dbfloatall` | Toggle all windows floating ↔ tiled |
| `dbtogglebar` | Show/hide the AGS bar |
| `dbackup` | GPG-encrypted local backup of configs |
