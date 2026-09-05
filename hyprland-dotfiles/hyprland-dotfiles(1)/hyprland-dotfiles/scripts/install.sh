#!/usr/bin/env bash
# ============================================================
#  Minimal Hyprland Dotfiles — installer
#  Safe to re-run. Existing configs are backed up (*.bak).
# ============================================================

set -euo pipefail

# ---- colors ----
BOLD=$(tput bold 2>/dev/null || echo "")
DIM=$(tput dim 2>/dev/null || echo "")
RESET=$(tput sgr0 2>/dev/null || echo "")
MAUVE='\033[38;5;183m'
BLUE='\033[38;5;111m'
GREEN='\033[38;5;150m'
YELLOW='\033[38;5;222m'
RED='\033[38;5;210m'
GREY='\033[38;5;245m'

info()    { printf "  ${BLUE}➜${RESET}  %s\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET}  %s\n" "$1"; }
warn()    { printf "  ${YELLOW}!${RESET}  %s\n" "$1"; }
error()   { printf "  ${RED}✗${RESET}  %s\n" "$1" >&2; }
step()    { printf "\n${MAUVE}${BOLD}%s${RESET}\n" "$1"; }

banner() {
cat <<'EOF'

   ▄█    █▄    ▄██   ▄      ▄███████▄    ▄████████
  ███    ███   ███   ██▄   ███    ███   ███    ███
  ███    ███   ███▄▄▄███   ███    ███   ███    ███
 ▄███▄▄▄▄███▄▄ ▀▀▀▀▀▀███   ███    ███   ███    ███
▀▀███▀▀▀▀███▀  ▄██   ███ ▀█████████▀  ▀███████████
  ███    ███   ███   ███   ███          ███    ███
  ███    ███   ███   ███   ███          ███    ███
  ███    █▀     ▀█████▀   ▄████▀        ███    █▀

EOF
printf "  ${GREY}minimal · declarative · catppuccin mocha${RESET}\n\n"
}

spin() {
  # run a command while showing a spinner; falls back silently if not a tty
  local msg="$1"; shift
  if [ ! -t 1 ]; then
    "$@"
    return
  fi
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  ("$@") &
  local pid=$!
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) % ${#frames} ))
    printf "\r  ${BLUE}%s${RESET}  %s" "${frames:$i:1}" "$msg"
    sleep 0.1
  done
  wait "$pid"
  printf "\r  ${GREEN}✓${RESET}  %s\n" "$msg"
}

clear 2>/dev/null || true
banner

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"

packages=(
  hyprland hyprpaper hyprlock hypridle
  waybar wofi mako kitty
  ttf-jetbrains-mono-nerd
  grim slurp wl-clipboard
  polkit-kde-agent qt6ct
  brightnessctl playerctl
)

step "Checking environment"
if ! command -v pacman >/dev/null 2>&1; then
  error "pacman not found — this installer targets Arch Linux (or an Arch-based distro)."
  exit 1
fi
success "Arch-based system detected"

if [ "$EUID" -eq 0 ]; then
  error "Don't run this as root — it will sudo when it needs to."
  exit 1
fi

step "Installing packages"
info "This may prompt for your sudo password"
sudo pacman -S --needed --noconfirm "${packages[@]}"
success "All packages installed"

step "Linking configs into ~/.config"
link() {
  local name="$1"
  local src="$DOTFILES_DIR/$name"
  local dst="$CONFIG_DIR/$name"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    warn "Backed up existing ${name} -> ${name}.bak"
  fi
  ln -sfn "$src" "$dst"
  success "Linked ${GREY}~/.config/${name}${RESET}"
}

mkdir -p "$CONFIG_DIR"
for dir in hypr waybar wofi kitty mako; do
  link "$dir"
done

step "Wallpaper"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DIR"
if [ ! -f "$WALLPAPER_DIR/mocha.png" ]; then
  warn "No wallpaper found at ~/Pictures/wallpapers/mocha.png"
  info "Drop an image there (or edit hypr/hyprpaper.conf) before first launch"
else
  success "Wallpaper found"
fi

printf "\n${GREEN}${BOLD}  Done!${RESET} Log out and select ${BOLD}Hyprland${RESET} at your display manager,\n"
printf "  or run ${BOLD}Hyprland${RESET} from a TTY.\n\n"
