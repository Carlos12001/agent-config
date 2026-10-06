# Global rules

These apply to every repository and project on this machine.

## Where repositories live

All repositories are kept in `~/Repos` (`%USERPROFILE%\Repos` on Windows).

- Clone and create repositories there. Do not create other folders for them, such as `~/Projects`.
- The only exception is a repository that an application needs at a fixed path (for example RetroArch saves in `~/.config/retroarch/saves`). Leave those where they are.
- If you find a repository somewhere else without that reason, say so and offer to move it; do not move it on your own.

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/) in every repository:

```text
<type>: <summary>
```

- Write the message in English, lowercase, imperative mood, no trailing period, summary under 72 characters.
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `build`, `ci`, `perf`, `style`.
- No scope unless the repository already uses them.
- One logical change per commit.
- A repository's own `AGENTS.md` or `CLAUDE.md` may add rules (for example a fixed message for generated commits); it does not replace this convention.

## README

Every repository must have two READMEs:

| File | Language | Role |
|---|---|---|
| `README.md` | English | Main README, the source of truth, so that any agent or person can read it |
| `README.es.md` | Spanish | Translation of `README.md` |

- Create both if the repository has none; if only one exists, write the other.
- Each file links to the other on the line under the title: `*[Español](README.es.md)*` and `*[English](README.md)*`.
- Update `README.md` first, then mirror the change in `README.es.md` in the same commit. The two must never drift apart.
- `AGENTS.md` and `CLAUDE.md` are written in English only.
- Keep the READMEs updated in the same change that alters what they describe.
