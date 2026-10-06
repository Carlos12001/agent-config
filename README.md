# Agent Config

*[Español](README.es.md)*

Global rules for the AI coding agents I use. They apply to every repository on my machines, so each project does not have to repeat them.

| File | What it is |
|---|---|
| [`AGENTS.md`](AGENTS.md) | The rules. Single source of truth |
| `CLAUDE.md` | Imports `AGENTS.md`, so Claude Code also applies the rules inside this repository |
| `install.sh` | Links the rules into the agent's global configuration (Linux / macOS) |

## The rules, in short

- **Location:** every repository lives in `~/Repos`, except `~/ROMs` and `saves`, which always sits inside RetroArch's configuration folder.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) in every repository, in English, lowercase, imperative mood.
- **README:** every repository has `README.md` in English (the main one) and `README.es.md` in Spanish, each linking to the other.
- **Context vault:** a private context vault exists at `~/Repos/storyline`.
- **Agent files:** `AGENTS.md` and `CLAUDE.md` are written in English.

The full text is in [`AGENTS.md`](AGENTS.md).

## Where the rules apply

| Where | Applies? |
|---|---|
| Claude Code on a machine where `install.sh` was run | Yes, in every folder. Rules are read when a session starts, so a change reaches new sessions, not ones already open |
| A machine where `install.sh` was not run | No |
| Claude on the web or in the mobile app | No: those chats do not read files from the machine |
| Other agents (GitHub Copilot, OpenClaw and so on) | Not globally. Each reads its own global file; see "Other agents" below |

The rules only say that the context vault exists. Its notes are not loaded automatically: an agent reads them when they are needed.

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
