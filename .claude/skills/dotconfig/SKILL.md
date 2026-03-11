---
name: dotconfig
description: Manage dotfiles via bare git repo. Use when working with dotfiles, nvim config, or committing changes to ~/.config files.
---

# Dotfiles Management

Dotfiles are managed via a bare git repo.

## Commands
- Alias: `dotconfig` = `/usr/bin/git --git-dir=$HOME/.dotconfig/ --work-tree=$HOME`
- Use `dotconfig status`, `dotconfig diff`, `dotconfig add`, `dotconfig commit` etc.
- In scripts/CI, expand the alias: `/usr/bin/git --git-dir=$HOME/.dotconfig/ --work-tree=$HOME <command>`

## Important: Paths Must Be Relative
All paths tracked by dotconfig are relative to `$HOME` (the work tree root). When adding files, always use paths relative to `$HOME` — never absolute paths. This ensures files check out correctly on any machine.

## Important: Keep This Skill Updated
When adding new configs to dotconfig, update the tracked configs list below.

## Tracked Configs
- `~/.config/nvim/` — Neovim (lazy.nvim, Neovim 0.11+)
- `~/.tmux.conf` — tmux (TPM plugins)
- `~/.bashrc`, `~/.zshrc` — shell configs
- `~/.aerospace.toml` — aerospace window manager (macOS)
- `~/.ripgreprc` — ripgrep defaults
- `~/.gitignore_global` — global gitignore
- `~/.cursor/` — Cursor editor settings and keybindings
- `~/.vim/vimrc` — legacy vim config
- `~/.claude/skills/dotconfig/` — this skill
- `~/CLAUDE.md` — Claude Code home config
