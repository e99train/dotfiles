# Copilot Instructions

## Repository Overview

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository managing personal configuration for macOS. Chezmoi manages dotfiles by mapping files in this repo to their target locations in `$HOME`.

## Chezmoi File Naming Conventions

Files and directories use chezmoi's source-state naming:

- `dot_` prefix → `.` prefix at target (e.g., `dot_zshrc` → `~/.zshrc`, `dot_config/` → `~/.config/`)
- `executable_` prefix → file is made executable at target
- `readonly_` prefix → file is made read-only at target
- Nested `dot_` applies recursively (e.g., `dot_config/tmux/plugins/tmux-gruvbox/dot_git/` → `~/.config/tmux/plugins/tmux-gruvbox/.git/`)

## Applying Changes

```sh
chezmoi apply            # apply all changes to home directory
chezmoi diff             # preview what would change
chezmoi add ~/.some/file # track a new dotfile
chezmoi edit ~/.some/file # edit a tracked file and apply
```

## Structure

| Source path | Target path | Purpose |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Zsh entry point — sources `~/.config/zsh/config.zsh` |
| `dot_config/zsh/` | `~/.config/zsh/` | Zsh config, plugins (znap), aliases |
| `dot_config/nvim/` | `~/.config/nvim/` | Neovim (LazyVim) config |
| `dot_config/tmux/` | `~/.config/tmux/` | Tmux config + TPM plugins |
| `dot_config/ghostty/` | `~/.config/ghostty/` | Ghostty terminal emulator |
| `dot_config/lazygit/` | `~/.config/lazygit/` | Lazygit config |
| `dot_config/yazi/` | `~/.config/yazi/` | Yazi file manager |
| `dot_config/eza/` | `~/.config/eza/` | eza (ls replacement) theme |
| `dot_ideavimrc` | `~/.ideavimrc` | IdeaVim config for JetBrains IDEs |
| `dot_p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k prompt config |

## Neovim Configuration

Built on [LazyVim](https://lazyvim.github.io/). Entry point: `dot_config/nvim/init.lua` → `require("config.lazy")`.

**Structure:**
- `lua/config/` — core config (options, keymaps, autocmds, lazy bootstrap)
- `lua/plugins/` — custom plugin specs that override or extend LazyVim defaults
- `lazyvim.json` — LazyVim extras enabled via the UI (managed by `:LazyExtras`)

**Active LazyVim extras** (from `lazyvim.json`):
- Languages: Go, TypeScript, JSON, YAML, Markdown, SQL, TOML, Zig, Ruby, Docker
- Editor: harpoon2, snacks_picker, inc-rename, refactoring, dial
- Formatting: biome
- Utilities: chezmoi, dot, rest, mini-hipatterns

**Lua formatting** (`stylua.toml`): 2-space indent, 120-column width. When editing Lua files, follow this style.

**Key customizations:**
- Colorscheme: `modus_vivendi` (modus-themes.nvim)
- Formatter for C#: `csharpier` via `dotnet csharpier format`
- Formatter for SQL: `sqlfluff --dialect=ansi`
- Formatter for JSON: `fixjson`
- LSP: `roslyn` (C#), `gh_actions_ls` (GitHub Actions YAML)
- `.env` files have diagnostics disabled
- GitHub Actions YAML detected via pattern `.github/**/workflows/**/*.ya?ml` → filetype `yaml.github`

**Custom keymaps** (beyond LazyVim defaults):
- `<BS>` → `<C-o>` (jump back), `<Del>` → `<C-i>` (jump forward)
- `<Up>`/`<Down>` in normal/visual → move lines
- `+`/`-` in visual → expand/shrink treesitter/LSP selection

## Zsh Configuration

Uses [znap](https://github.com/marlonrichert/zsh-snap) as the plugin manager. Main config is in `dot_config/zsh/config.zsh`.

**Key tools integrated:**
- `mise` — runtime version manager (`mise activate zsh`), `.env` files loaded via `MISE_ENV_FILE=.env`
- `direnv` — per-directory env vars
- `zoxide` — smart `cd` replacement (aliased as `cd`)
- `powerlevel10k` — prompt
- `zsh-vim-mode` — vi key bindings with cursor shape feedback
- `yazi` — file manager; `y` function changes shell cwd on quit

**Aliases:** `ls` → `eza`, tmux session shortcuts (`ta`, `ts`, `tl`, `tksv`, `tkss`)

**Secret management:** `GITHUB_LS_TOKEN` retrieved via `chezmoi secret keyring`.

## Tmux

- Prefix: `C-Space` (changed from default `C-b`)
- Pane splits: `|` (horizontal), `-` (vertical)
- Pane navigation: `Alt+Arrow` (no prefix needed)
- Session switcher: `C-j` opens `tms switch` in a popup
- Plugin manager: [TPM](https://github.com/tmux-plugins/tpm) — plugins in `dot_config/tmux/plugins/`
- Active plugins: `tmux-sensible`, `vim-tmux-navigator`, `tmux-powerline`
- Windows and panes indexed from 1
