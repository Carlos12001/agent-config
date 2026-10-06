# Agent Config

*[English](README.md)*

Reglas globales para los agentes de IA de programación que uso. Se aplican a todos los repositorios de mis equipos, para que cada proyecto no tenga que repetirlas.

| Archivo | Qué es |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Las reglas. Única fuente de verdad |
| `CLAUDE.md` | Importa `AGENTS.md`, para que Claude Code también aplique las reglas dentro de este repositorio |
| `install.sh` | Enlaza las reglas en la configuración global del agente (Linux / macOS) |

## Las reglas, en resumen

- **Ubicación:** todo repositorio vive en `~/Repos`, salvo que una aplicación lo necesite en una ruta fija.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) en todos los repositorios, en inglés, en minúscula y en imperativo.
- **README:** todo repositorio tiene `README.md` en inglés (el principal) y `README.es.md` en español, cada uno con un enlace al otro.
- **Archivos para agentes:** `AGENTS.md` y `CLAUDE.md` se escriben en inglés.

El texto completo está en [`AGENTS.md`](AGENTS.md).

## Instalación

### Linux / macOS

```bash
git clone git@github.com:Carlos12001/agent-config.git ~/Repos/agent-config
~/Repos/agent-config/install.sh
```

`install.sh` crea este enlace simbólico, así que basta un `git pull` para actualizar las reglas:

```text
~/.claude/CLAUDE.md  →  ~/Repos/agent-config/AGENTS.md
```

Si `~/.claude/CLAUDE.md` ya existe como archivo normal, antes se renombra a `CLAUDE.md.bak-<fecha>`; un enlace antiguo simplemente se reemplaza. Volver a ejecutar el script no cambia nada.

### Windows

```powershell
git clone git@github.com:Carlos12001/agent-config.git $HOME\Repos\agent-config
Copy-Item $HOME\Repos\agent-config\AGENTS.md $HOME\.claude\CLAUDE.md
```

Es una copia, no un enlace: repite el `Copy-Item` después de cada `git pull`.

> [!NOTE]
> Los pasos de Windows todavía no se han probado.

### Otros agentes

`install.sh` solo configura Claude Code. Los demás agentes leen sus reglas globales de su propio archivo; enlaza o copia `AGENTS.md` ahí a mano.

## Cambiar una regla

1. Edita `AGENTS.md`.
2. Refleja el cambio en el resumen de `README.md` y `README.es.md` si le afecta.
3. Haz commit con un mensaje de Conventional Commits y súbelo.

Un repositorio puede añadir sus propias reglas en su `AGENTS.md` o `CLAUDE.md`; amplían estas, no las reemplazan.
