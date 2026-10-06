# Agent Config

*[Español](README.es.md)*

Global rules for the AI coding agents I use. They apply to every repository on my machines, so each project does not have to repeat them.

| File | What it is |
|---|---|
| [`AGENTS.md`](AGENTS.md) | The rules. Single source of truth |
| `CLAUDE.md` | Imports `AGENTS.md`, so Claude Code also applies the rules inside this repository |
| `install.sh` | Links the rules into the agent's global configuration (Linux / macOS) |

## The rules, in short

- **Location:** every repository lives in `~/Repos`, except `~/ROMs` and any repository an application needs at a fixed path.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) in every repository, in English, lowercase, imperative mood.
- **README:** every repository has `README.md` in English (the main one) and `README.es.md` in Spanish, each linking to the other.
- **Context vault:** on "crea contexto", the agent updates my private notes vault; only I can publish it.
- **Agent files:** `AGENTS.md` and `CLAUDE.md` are written in English.

The full text is in [`AGENTS.md`](AGENTS.md).

## Installation

### Linux / macOS

```bash
git clone git@github.com:Carlos12001/agent-config.git ~/Repos/agent-config
~/Repos/agent-config/install.sh
```

`install.sh` creates this symbolic link, so a `git pull` is enough to update the rules:

```text
~/.claude/CLAUDE.md  →  ~/Repos/agent-config/AGENTS.md
```

If `~/.claude/CLAUDE.md` already exists as a regular file, it is renamed to `CLAUDE.md.bak-<date>` first; an old link is simply replaced. Running the script again changes nothing.

### Windows

```powershell
git clone git@github.com:Carlos12001/agent-config.git $HOME\Repos\agent-config
Copy-Item $HOME\Repos\agent-config\AGENTS.md $HOME\.claude\CLAUDE.md
```

This is a copy, not a link: repeat the `Copy-Item` after every `git pull`.

> [!NOTE]
> The Windows steps have not been tested yet.

### Other agents

Only Claude Code is set up by `install.sh`. Other agents read their global rules from their own file; link or copy `AGENTS.md` there by hand.

## Changing a rule

1. Edit `AGENTS.md`.
2. Mirror the change in the summary of `README.md` and `README.es.md` if it affects it.
3. Commit with a Conventional Commits message and push.

A repository can add its own rules in its `AGENTS.md` or `CLAUDE.md`; they extend these, they do not replace them.
