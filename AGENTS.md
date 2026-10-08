# Global rules

These apply to every repository and project on this machine.

## Where repositories live

All repositories are kept in `~/Repos` (`%USERPROFILE%\Repos` on Windows).

- Clone and create repositories there. Do not create other folders for them,
  such as `~/Projects`.
- Exceptions, which stay where they are:
  - `saves`: always inside RetroArch's configuration folder, at
    `~/.config/retroarch/saves` (`C:\RetroArch-Win64\saves` on Windows).
  - `~/ROMs`.
- If you find a repository somewhere else without that reason, say so and offer
  to move it; do not move it on your own.

## Commits

Use [Conventional Commits][cc] in every repository:

```text
<type>: <summary>
```

- Write the message in English, lowercase, imperative mood, no trailing period,
  summary under 72 characters.
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `build`, `ci`,
  `perf`, `style`.
- No scope unless the repository already uses them.
- One logical change per commit.
- A repository's own `AGENTS.md` or `CLAUDE.md` may add rules (for example a
  fixed message for generated commits); it does not replace this convention.

## README

Every repository must have two READMEs:

| File | Language | Role |
| --- | --- | --- |
| `README.md` | English | Main README, the source of truth, so that any agent or person can read it |
| `README.es.md` | Spanish | Translation of `README.md` |

- Create both if the repository has none; if only one exists, write the other.
- Each file links to the other on the line under the title:
  `*[Español](README.es.md)*` and `*[English](README.md)*`.
- Update `README.md` first, then mirror the change in `README.es.md` in the same
  commit. The two must never drift apart.
- `AGENTS.md` and `CLAUDE.md` are written in English only.
- Keep the READMEs updated in the same change that alters what they describe.

## Line length

Write every source file with lines of at most 80 columns. This covers code in
any language (Rust, Python, C, C++, shell and so on), configuration files and
Markdown.

- Break the line instead of going over the limit.
- When a project has a formatter, set it to 80 so that it agrees with this rule:
  `max_width = 80` for rustfmt, `line-length = 80` for Ruff or Black,
  `ColumnLimit: 80` for clang-format.
- Only a line that cannot be split may be longer: a URL, a Markdown table row,
  or a string or path that would stop working if it were wrapped.
- If a repository already sets another limit in its formatter or linter
  configuration, that limit applies there.
- Do not rewrap vendored or generated files.

## Markdown

Every Markdown file you create or edit must pass [markdownlint][mdl] with its
default rules, so that all of them are written the same standard way. This
applies outside a repository too.

- Run it with `markdownlint-cli2` before reporting the work as finished, and fix
  what it reports. `markdownlint-cli2 --fix` corrects most problems; wrap long
  lines by hand.
- Every repository has a `.markdownlint-cli2.jsonc` at its root. Create it if it
  is missing:

  ```jsonc
  {
    "config": {
      "default": true,
      "MD013": { "line_length": 80, "tables": false }
    },
    "globs": ["**/*.md"],
    "gitignore": true
  }
  ```

- Link to a URL with a reference, not inline: write `[text][label]` in the
  paragraph and put `[label]: https://...` at the end of the file, one per line,
  with a short lowercase label. The text stays readable and a long URL never
  pushes a line past 80 columns. A link to a file in the same repository, such
  as `[Español](README.es.md)`, stays inline.
- Do not turn a rule off, or ignore a file, to hide an error. An exception needs
  a real reason, written as a comment next to it.
- If `markdownlint-cli2` is not installed, install it (`markdownlint-cli2` in
  the Arch repositories, `npm install -g markdownlint-cli2` elsewhere). If you
  cannot, say that the files were not linted.

## Temporary files and logs

Never leave files where they do not belong. Do not write logs, temporary files,
backups or scratch output in the home folder, the desktop, the current
directory, next to a script, next to the file they belong to, or inside a
repository's working tree.

### Default: create nothing

- A script prints its progress to the terminal. Write a log file only when the
  output must outlive the run, for example a background service or a long
  detached job.

### Temporary files

They must be created with the system's tool, in the system's place, and removed
when the work ends, including when it is interrupted (`trap` in Bash,
`try`/`finally` in PowerShell).

| System | Where | How |
| --- | --- | --- |
| Linux | `$XDG_RUNTIME_DIR` for small per-session files; otherwise `${TMPDIR:-/tmp}` | `mktemp` / `mktemp -d` |
| Linux, must survive a reboot | `/var/tmp` | `mktemp -p /var/tmp` |
| macOS | `$TMPDIR` | `mktemp` / `mktemp -d` |
| Windows | `%TEMP%` (`$env:TEMP`) | `New-TemporaryFile`, or a folder under `$env:TEMP` |

An agent's own scratch work goes in the session scratch directory its tool
provides, or in the places above, and is deleted before the task is reported as
finished.

### Logs

Unless the owner asks for a specific place, a log goes where the operating
system expects it, in a folder named after the program:

| System | A program run by the user | A service or system-wide program |
| --- | --- | --- |
| Linux | `${XDG_STATE_HOME:-~/.local/state}/<app>/` | The journal (`journalctl`), or `/var/log/<app>/` |
| macOS | `~/Library/Logs/<app>/` | `/Library/Logs/<app>/` |
| Windows | `%LOCALAPPDATA%\<App>\Logs\` | `%ProgramData%\<App>\Logs\`, or the Event Log |

- Keep logs small: at most 5 files and 10 MB in total per program. Rotate, and
  delete the oldest when a limit is reached.
- Never write passwords, tokens or keys to a log.
- Tell the owner where the log is when you create one.

### Backups

Before changing a configuration file, or any file that is not tracked by Git,
make a backup copy. A backup is temporary too, so it never stays next to the
original: it goes in one fixed place.

| System | Where |
| --- | --- |
| Linux, macOS | `${XDG_STATE_HOME:-~/.local/state}/backups/<app>/` |
| Windows | `%LOCALAPPDATA%\Backups\<App>\` |

- Name it `<original name>.<YYYYMMDD-HHMMSS>.bak`, so several backups of the
  same file do not collide and their age is visible.
- Create the folder with access for the owner only (`chmod 700`): configuration
  files often hold tokens.
- Tell the owner the full path of the backup when you make it.
- Keep few of them: at most 5 backups per file, and none older than 30 days.
  Delete the extra ones the next time you write a backup for the same program,
  and delete one earlier when the owner confirms the change works.
- A file tracked by Git needs no backup: the history is the backup.

### Configuration and data folders stay clean

`~/.config` and `~/.local/share` (on Windows, `%APPDATA%`) hold only what a
program needs in order to work. Nothing disposable goes there: no logs, no
backups, no caches, no temporary or scratch files, no downloads.

| Kind | Linux | Windows |
| --- | --- | --- |
| Configuration the program reads | `${XDG_CONFIG_HOME:-~/.config}/<app>/` | `%APPDATA%\<App>\` |
| Data the program cannot recreate | `${XDG_DATA_HOME:-~/.local/share}/<app>/` | `%LOCALAPPDATA%\<App>\` |
| Cache, anything that can be recreated | `${XDG_CACHE_HOME:-~/.cache}/<app>/` | `%LOCALAPPDATA%\<App>\Cache\` |
| Logs and backups | `${XDG_STATE_HOME:-~/.local/state}/`, as described above | `%LOCALAPPDATA%`, as described above |

Before adding a file to a configuration or data folder, ask whether the program
would break without it. If not, it does not belong there.

### Before finishing

List what you created outside the repository you were asked to work in, remove
what is not needed, and tell the owner what remains and why.

## Context vault

A private context vault exists at `~/Repos/storyline`. Its own `AGENTS.md`
explains how to use it.

[cc]: https://www.conventionalcommits.org/
[mdl]: https://github.com/DavidAnson/markdownlint
