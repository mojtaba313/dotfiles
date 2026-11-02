# Abyss Cyan dotfiles

Dark + cyan Hyprland setup for a web developer / physician.
Calm at 3am, punchy when focused. Stow-managed, Arch-first.

## Theme — Abyss Cyan

| role    | color                                                       |
| ------- | ----------------------------------------------------------- |
| bg deep | `#060b11`                                                   |
| bg      | `#0b1219`                                                   |
| surface | `#111b26` / `#1a2a3a`                                       |
| fg      | `#d9e8f2` / muted `#5d7488`                                 |
| primary | cyan `#00e5ff` → teal `#2dd4bf` gradient (borders, active)  |
| ok      | `#3dd68c` • warn `#ffcc57` • alert `#ff6b81` • info `#5aa9ff` |

Font: **JetBrainsMono Nerd Font Mono** everywhere (bar, terminal, lock, rofi).

## Layout

```
bash/      → ~/.bashrc + ~/.bashrc.d/ (modular: base, dev, network, focus…)
hypr/      → ~/.config/hypr/ (lua modules + paper/lock/idle + scripts/)
kitty/     → ~/.config/kitty/ (Abyss Cyan theme, tabs bottom, 0.88 blur bg)
waybar/    → ~/.config/waybar/ (glass bar + backlight helper)
starship/  → ~/.config/starship.toml (cyan powerline prompt)
mako/      → ~/.config/mako/ (notifications)
nvim/      → ~/.config/nvim/ (minimal.vim for quick notes)
rofi/      → ~/.config/rofi/ (abyss-cyan theme, clipmenu, power menu)
git/       → ~/.gitconfig (fill in name/email)
wallpapers/→ generated abyss-cyan.jpg + vertical (see wallpapers/generate.sh)
install.sh + packages-arch.txt + packages-aur.txt
```

## Install (Arch)

```bash
cd ~/dotfiles
sudo pacman -S --needed - < packages-arch.txt
yay -S --needed - < packages-aur.txt   # optional
./install.sh
```

`install.sh` stows every package, links wallpapers to
`~/Pictures/Wallpapers/`, makes waybar/rofi scripts executable,
and reloads hypr/waybar/mako.

## Keybinds (SUPER = main)

| keys | action |
| ---- | ------ |
| `SUPER+Return` / `Q` | kitty |
| `SUPER+R` | rofi drun |
| `SUPER+E` / `B` / `O` | dolphin / firefox / vscode |
| `SUPER+M` / `J` | dolphin in `$MEDICAL_DIR` / `$PROJECTS_DIR` |
| `SUPER+W` / `V` / `F` / `T` / `G` | close / float / fullscreen / tilesplit / group |
| `SUPER+I` | **hyprworm** window switcher (fuzzel GUI, all workspaces) |
| `SUPER+HJKL` + arrows | focus |
| `SUPER+SHIFT+HJKL` / arrows | move window |
| `SUPER+1…0` / `SHIFT` / `CTRL` | workspace / move / move-silent |
| `SUPER+S` | scratchpad |
| `SUPER+C` / `SHIFT+C` | clipboard (history + pins) / pinned only |
| `SUPER+Z` | toggle bar (with notification) |
| `SUPER+SHIFT+B` | **force bar back** if it ever disappears |
| `SUPER+SHIFT+Z` | zen mode (hide bar + fullscreen) |
| `SUPER+ESC` / `CTRL+L` | lock (hyprlock) |
| `SUPER+SHIFT+Q` | power menu |
| `SUPER+SHIFT+E` | exit Hyprland |
| `SUPER+SHIFT+R` | reload config |
| `SUPER+N` | show/hide pinned notes pad (`~/notes.txt` in minimal nvim, all workspaces) |
| `SUPER+CTRL+N` | dismiss notification |
| `SUPER+SHIFT+N` | night-shift warm tint (gammastep 3500K) |
| `Print` / `SHIFT+Print` / `SUPER+Print` | region→clipboard / full→clipboard / region→file |

> `SUPER+L` moves focus right (vim-style), so lock lives on `ESC`.
> Togglesplit is `SUPER+T`; `SUPER+J` opens your projects folder.

## hyprworm — Window Switcher

`SUPER+I` opens **hyprworm**, a fuzzel-based window switcher that shows all
open windows across workspaces in a single overlay. Select a window to focus
it (and switch to its workspace automatically).

| key | action |
| --- | ------ |
| `SUPER+I` | open hyprworm (toggle) |
| Type to filter | fuzzel fuzzy matching |
| `Enter` | focus selected window |
| `Esc` | close without switching |

Config: `~/.config/hyprworm/config`

```ini
launcher = fuzzel --dmenu --width 62 --y 4
show_title = true
sort_order = workspace
special_workspace_position = top
workspace_alias_special = "⭐ "
workspace_alias_work = "💼 "
workspace_alias_gaming = "🎮 "
```

Special workspaces (scratchpad) get a ⭐ prefix and sort to the top.

## Clipboard with pins

`SUPER+C` opens `hypr/scripts/clipmenu.sh` (floating rofi, no extra window):

| key | action |
| --- | ------ |
| `Enter` | copy the entry **and paste it back** where you came from |
| `Ctrl+1` | **pin** it (survives cliphist eviction) |
| `Ctrl+2` | unpin, or delete from history |
| `Ctrl+Shift+W` | clear all pins (asks first) |

Selecting with `Enter` behaves like a real clipboard manager (Win+V, clipman):
the menu records which window had focus before it opened, then sends the paste
shortcut back to that window — `Ctrl+Shift+V` for terminals (kitty, foot,
ghostty, wezterm, alacritty), `Ctrl+V` everywhere else. Copy-only behaviour is
available via `CLIPMENU_PASTE=0 clipmenu.sh`. A `󰐑 Copied …` notification
confirms each pick, so a no-op is never silent.

Pins are stored base64-encoded in `~/.local/state/clipmenu/pinned.tsv` and
always sort to the top of the list — handy for things you retype daily.
`SUPER+SHIFT+C` (or `clips`) shows only the pinned entries.
Shell aliases: `clip` (history + pins) and `clips` (pinned only).
Images/binary entries can be copied but not pinned (bash variables cannot hold
null bytes, so pinning one would corrupt it) — the menu says so instead.

### How clipboard capture works, and one thing never to do

History capture is `wl-paste --watch cliphist store`, supervised by
`scripts/clipwatch.sh` so it restarts itself if it ever dies.

**Never pass `--type` to that command.** `--type text` asks for a MIME type
named exactly `text`, which essentially nothing offers — kitty, Brave and
Chromium all offer `text/plain;charset=utf-8`. The watcher still starts, looks
healthy in `ps`, and silently records *nothing*, because every offer fails the
type check. That single flag is why the history appeared frozen at 750 entries
while the menu itself worked fine.

### Why the menu parses rofi's output defensively

Rofi reports a custom key through its **exit status** (`10` for `-kb-custom-1`,
`11` for `-kb-custom-2`, …) and still prints only the selected line. The menu
therefore maps the status to pin/unpin/clear, and scans the output for the first
all-digit line as the selection. Scanning for a literal `custom1` line would
silently turn every key into "copy" — which is exactly the bug that was fixed.

## Waybar

Floating top bar: **workspace buttons** • window title | clock | cpu • mem •
temp • volume • **brightness** • net • tray.

- **Brightness** (``): scroll to step ±5%, click to toggle 100% / 30%
  (handy when reading charts or notes late at night). The icon steps down as the
  panel dims, and the text turns **amber below 50%** so a dim screen is obvious
  at a glance. Hardware keys (`XF86MonBrightnessUp/Down`) still work as before.

The pomodoro (`󰽉`) and eye-care (`󰔟`) bar modules were removed on request —
they were noise next to the real system stats. The **shell** helpers still
exist if you want them: `focus 25` (terminal pomodoro), `eyes` (20s break),
`hydrate 250`, `note …`, `med-note`, `standup`. Say the word and I'll strip
those too.

### Why the workspaces use `ext/workspaces`

Waybar's `hyprland/workspaces` module cannot switch workspaces on Hyprland
0.55+ (this machine runs 0.56): Hyprland replaced its request socket with
**Hyprwire**, which waybar 0.15 does not speak, so its `activate` action is
silently rejected. The same Hyprland build also implements the standard
`ext-workspace-v1` protocol, and waybar 0.15 ships an `ext/workspaces` module
that speaks it.

So the bar uses `ext/workspaces` directly:

- one module, driven entirely by compositor events — no daemon, no polling,
  no `hyprctl`/`jq` forks per button;
- clicking a button sends the protocol's `activate` request, so switching
  workspaces works without Hyprland's broken request socket;
- `workspace_rule` keeps 1–5 persistent, so five buttons are always present;
  any other workspace appears automatically when you use it;
- scroll-to-switch is `SUPER` + wheel (global keybind), not on the bar itself.

| key | alias | action |
| --- | --- | --- |
| click `1`–`5` | — | switch workspace |
| `SUPER` + wheel | — | next / previous workspace |
| `SUPER+Z` | `wtoggle` | toggle bar, always notifies you which state it ended in |
| `SUPER+SHIFT+B` | `wshow` | force the bar back (restarts waybar) |
| `SUPER+SHIFT+Z` | `whide` | hide bar + fullscreen |
| — | `bar status` | prints `visible` / `hidden` |

### Look

The bar is deliberately flat: only two things carry a background — the active
workspace and the clock. Everything else is plain text that tints cyan on hover,
because a row of boxed pills reads as clutter on a 1366px-wide panel.

Waybar's stateless `SIGUSR1` toggle is deliberately avoided: hide the bar once
and it stays invisible while still owning its layer surface, so clicks land on
whatever is behind it. `show` restarts waybar instead, because a restart is the
only way to be certain the bar is really painted.

Shell helpers: `wreload` (SIGUSR2 reload in place), `wshow`, `whide`, `wtoggle`.

Hardware notes: the bar reads CPU temp from `hwmon5` (coretemp). Battery and
Bluetooth modules were removed — this machine reports no battery
(`/sys/class/power_supply` has only `AC0`) and no Bluetooth controller, and
those two modules only logged errors. Re-add them to `modules-right` if your
hardware has them.

## Wallpapers

`wallpapers/abyss-cyan.jpg` (+ vertical) are generated, not hand-drawn:

```bash
bash wallpapers/generate.sh     # ~20s, pure ImageMagick
```

Glows are radial gradients rather than blurred circles and grain is applied at
render scale before upscaling — same look, ~30x faster than the naive version.
JPEG is deliberate: the film grain that stops the gradient looking flat costs
~600 KB as JPG versus ~17 MB as PNG. `install.sh` symlinks both into
`~/Pictures/Wallpapers/`; `hyprpaper.conf` and `hyprlock.conf` use them.

## Shell

`~/.bashrc.d/` is auto-sourced (spacesafe, sorted):

- `customes.sh` — history, colors, starship, nvm/pnpm/code paths (yours, kept)
- `dev.sh` — `dot/stow-all/hreload`, git (`gs/gc/gp/glg…`), docker, pnpm (`nd/nb/nt`), `ports/serve`
- `network.sh` — `vpn on|off|status`, `myip`
- `functions.sh` — `mkcd/bak/extract/port/killport/weather`
- `focus.sh` — `focus 25`, `eyes`, `hydrate 250`, `note …`, `med-note`, `standup`
- `aliases.sh` — safe `rm/cp/mv`, `eza/bat` when installed

Starship prompt: cyan `╭─ OS path git │ lang ⏱ ╰─➜`, shows node/bun/docker/python/rust/go/php + cmd duration.

## Health-conscious defaults

- Low-glare palette + 0.88 terminal opacity + blur — easier night shifts.
- `SUPER+SHIFT+N` warm tint, `eyes` 20s break, waybar eye-care nudges every 20 min.
- `hydrate` logs water, `focus 25` enforces single-tasking, `med-note` gives a study stub (never real PHI).

## First-run checklist

1. `git/.gitconfig` → set name + email.
2. `hypr/.config/hypr/conf/input.lua` → add `,ir` layout if you type Persian.
3. `hypr/.config/hypr/conf/monitors.lua` → pin resolution/scale if `auto` misbehaves.
4. Reboot or `hyprctl reload`, then `SUPER+R` to feel the theme.
