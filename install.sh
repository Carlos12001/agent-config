#!/bin/bash

# Link the global agent rules into each agent's configuration directory

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_file="$repo_dir/AGENTS.md"

link_rules() {
  local target="$1"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink -f "$target")" == "$source_file" ]]; then
    echo -e "\033[32mAlready linked: $target\033[0m"
    return
  fi

  # A link to somewhere else (for example the repository was moved) is just replaced
  if [[ -L "$target" ]]; then
    rm "$target"
  fi

  # Keep whatever was there before
  if [[ -e "$target" ]]; then
    local backup
    backup="$target.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$target" "$backup"
    echo -e "\033[33mExisting file saved as: $backup\033[0m"
  fi

  ln -s "$source_file" "$target"
  echo -e "\033[32mLinked: $target -> $source_file\033[0m"
}

# Claude Code reads ~/.claude/CLAUDE.md in every project
link_rules "$HOME/.claude/CLAUDE.md"
