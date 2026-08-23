# WezTerm

WezTerm is a GPU-accelerated, cross-platform terminal emulator and multiplexer, written in Rust by Wez Furlong. "Terminal emulator" means it's the window/app that hosts your shell (zsh, bash, fish, etc.) and renders the text. "Multiplexer" means it also has built-in tmux-like features — splitting panes, tabs, and persistent sessions — without needing a separate tool like `tmux` or `screen`.

## Index

- [What makes it different from other terminal emulators](#what-makes-it-different-from-other-terminal-emulators)
- [Key features](#key-features)
- [Debug console](#debug-console)

## What makes it different from other terminal emulators

- **Config is a real programming language (Lua), not a data file.** Most terminal emulators (Alacritty, Kitty, iTerm2, GNOME Terminal) use YAML, TOML, or GUI settings panels — static data with no logic. WezTerm's config file is a Lua script that gets *executed*, meaning you can use variables, conditionals, loops, and functions directly in your config. Example: automatically pick a different font size depending on which machine you're on, without any special templating syntax.

- **Multiplexer built in.** Kitty and Alacritty are terminal emulators only — you still need tmux for panes/sessions. WezTerm bundles this natively, including the ability to detach/reattach sessions and even multiplex over SSH.

- **GPU-accelerated rendering with multiple backends.** You can choose how WezTerm draws itself to the screen: `WebGpu` (modern, uses Vulkan/Metal/DirectX12 depending on OS), `OpenGL` (older, universally supported), or `Software` (CPU-only fallback for when GPU drivers misbehave).

- **Extremely detailed Lua API.** Nearly every visual and behavioral aspect is scriptable: custom keybindings with arbitrary Lua logic, custom status bars, event hooks (e.g. run a function when a new tab opens), and even generating config values at runtime (like reading installed fonts or enumerating available GPUs).

- **Single Rust binary, actively developed**, with frequent releases and a real changelog — config options are versioned, so docs tell you exactly which WezTerm version introduced or changed a given setting.

## Color profiles supported

WezTerm supports all three color tiers:

- **Standard 8/16 ANSI colors** — universal, oldest tier.
- **256-color (Xterm extended)** — fully supported.
- **True color (24-bit RGB hex)** — fully supported; WezTerm is genuinely capable of this natively.

```lua
config.colors = {
  foreground = '#c5c9c5',  -- true color hex works directly
  background = '#181616',
}
```

**`TERM` note**: WezTerm can fully display true color and other fancy features, but some programs first ask "what can you do?" via a setting called `TERM`, and by default WezTerm answers with a modest "just 256 colors" — so those programs hold back even though WezTerm could actually show more; installing WezTerm's own more accurate answer (`term = "wezterm"`) fixes this by telling programs the full truth, though it's optional and only matters if a specific program you use is being overly cautious.

## Key features

- Ligature support and fallback fonts (render missing glyphs from a secondary font automatically)
- Tabs, splits/panes, and workspaces
- Built-in SSH client and serial port support
- Searchable scrollback and "quick select" mode (jump to on-screen text/URLs via keyboard)
- Hyperlink detection and clickable links
- Custom key and mouse bindings, fully scriptable
- Session/pane persistence via its multiplexer daemon
- Plugin system (community Lua plugins for status bars, themes, etc.)
- Live config reload — no need to restart the terminal after editing `wezterm.lua`

## Debug console

WezTerm has a built-in debug overlay — a live Lua console running inside WezTerm itself, useful for checking what WezTerm sees on your system without installing anything extra.

**Open it**: `Ctrl+Shift+L`

**What it shows immediately, on open**:

- WezTerm version, target platform
- Window environment (X11/Wayland)
- Lua version in use
- The active GPU/rendering backend — e.g. `WebGPU: name=..., device_type=..., backend=Vulkan, driver=...`

**What you can do inside it**:

- Type any Lua expression or statement and hit Enter to run it live, e.g.:
  ```lua
  wezterm.gui.enumerate_gpus()
  ```
  lists every GPU WezTerm detects, with backend (Vulkan/Gl/etc.), device type (Discrete/Integrated/Cpu), and driver — useful for confirming which GPU/backend `front_end = 'WebGpu'` actually picked.
- Inspect `config` values, test small Lua snippets, or call any `wezterm.*` function directly — since this console runs inside the same Lua environment as your config file.
- View error messages if `wezterm.lua` fails to load — this overlay is also where WezTerm surfaces config syntax/validation errors.

**Exit**: `Esc` or `Ctrl+D`