#!/bin/bash

# Link the global agent rules into each agent's configuration directory

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_file="$repo_dir/AGENTS.md"

backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/backups/agent-config"

# At most 5 backups per file, and none older than 30 days
prune_backups() {
  local name="$1"
  find "$backup_dir" -maxdepth 1 -type f -name "$name.*.bak" -mtime +30 -delete
  find "$backup_dir" -maxdepth 1 -type f -name "$name.*.bak" \
    -printf '%T@ %p\n' |
    sort -rn | tail -n +6 | cut -d' ' -f2- | while IFS= read -r old_backup; do
      rm -f "$old_backup"
    done
}

link_rules() {
  local target="$1"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink -f "$target")" == "$source_file" ]]; then
    echo -e "\033[32mAlready linked: $target\033[0m"
    return
  fi

  # A link to somewhere else (for example the repository was moved) is just
  # replaced
  if [[ -L "$target" ]]; then
    rm "$target"
  fi

  # Keep whatever was there before, in the fixed backups folder (never next to
  # the original)
  if [[ -e "$target" ]]; then
    local backup
    mkdir -p "$backup_dir"
    chmod 700 "$backup_dir"
    backup="$backup_dir/$(basename "$target").$(date +%Y%m%d-%H%M%S).bak"
    mv "$target" "$backup"
    echo -e "\033[33mExisting file saved as: $backup\033[0m"
    prune_backups "$(basename "$target")"
  fi

  ln -s "$source_file" "$target"
  echo -e "\033[32mLinked: $target -> $source_file\033[0m"
}

# Claude Code reads ~/.claude/CLAUDE.md in every project
link_rules "$HOME/.claude/CLAUDE.md"
