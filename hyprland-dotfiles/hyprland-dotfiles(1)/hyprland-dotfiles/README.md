# Minimal Hyprland Dotfiles

A clean, declarative Hyprland setup for Arch Linux. Catppuccin Mocha palette,
rounded corners, soft blur, subtle animations — nothing flashy, just legible
and consistent.

> Replace `YOUR_USERNAME` below with your actual GitHub username once
> you've pushed the repo.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/hyprland-dotfiles.git ~/hyprland-dotfiles
cd ~/hyprland-dotfiles
./scripts/install.sh
```

The installer installs the required packages with `pacman` and symlinks
each config folder into `~/.config` — anything already there gets backed
up to `name.bak` first, so it's safe to run more than once.

## What's included

| Path                  | Purpose                                    |
|------------------------|--------------------------------------------|
| `hypr/hyprland.conf`   | Main compositor config: binds, rules, look |
| `hypr/hyprpaper.conf`  | Wallpaper daemon                           |
| `hypr/hyprlock.conf`   | Lock screen                                |
| `hypr/hypridle.conf`   | Idle timeouts (lock / dpms / suspend)      |
| `waybar/`              | Status bar (config + CSS)                  |
| `wofi/`                | App launcher (config + CSS)                |
| `kitty/kitty.conf`     | Terminal emulator theme                    |
| `mako/config`          | Notification daemon                        |
| `scripts/install.sh`   | Installs packages + symlinks configs       |

## Before you start Hyprland

1. Drop a wallpaper at `~/Pictures/wallpapers/mocha.png`, or edit the path
   in `hypr/hyprpaper.conf` and `hypr/hyprlock.conf`.
2. Make sure a Nerd Font is installed — the installer pulls in
   `ttf-jetbrains-mono-nerd`. Swap the font name across the configs if you
   prefer another one.
3. If you use a login manager (SDDM, etc.), select "Hyprland" as your
   session. Otherwise run `Hyprland` from a TTY.

## Key bindings (defaults)

- `SUPER + Return` — terminal
- `SUPER + D` — app launcher
- `SUPER + Q` — close window
- `SUPER + E` — file manager
- `SUPER + V` — toggle floating
- `SUPER + F` — fullscreen
- `SUPER + L` — lock screen
- `SUPER + 1..0` — switch workspace
- `SUPER + SHIFT + 1..0` — move window to workspace
- `SUPER + arrows` — move focus
- `SUPER + SHIFT + arrows` — move window
- `Print` — region screenshot to clipboard

All binds live at the bottom of `hypr/hyprland.conf` — edit freely.

## Customizing

Everything is declarative — colors are Catppuccin Mocha hex values used
directly in each config, so a find-and-replace across the repo is enough
to re-theme (e.g. swap to Catppuccin Latte, Nord, or Gruvbox). The main
values to touch:

- `hypr/hyprland.conf` → `general` and `decoration` blocks for borders,
  gaps, rounding, blur strength
- `waybar/style.css` → bar colors and module pill backgrounds
- `wofi/style.css`, `kitty/kitty.conf`, `mako/config` → matching accents

## Publishing this to your own GitHub

If you're starting from this downloaded folder rather than a repo you
already have:

```bash
cd hyprland-dotfiles
git init
git add .
git commit -m "Initial commit: minimal Hyprland dotfiles"
git branch -M main
```

Then create an empty repo on GitHub (github.com/new — don't initialize it
with a README or .gitignore), and push:

```bash
git remote add origin https://github.com/YOUR_USERNAME/hyprland-dotfiles.git
git push -u origin main
```

After that, update the `YOUR_USERNAME` placeholder in this README to match,
commit, and push again.

Enjoy the setup.
