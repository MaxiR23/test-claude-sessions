---
title: Revisión
sidebar:
  order: 4
description: Cómo se elige entre camino corto y completo, y cómo es la revisión.
---

`scripts/loop-path.sh` imprime `short` o `full` según los archivos cambiados.

## Camino corto

Imprime `short` solo cuando todos los archivos cambiados son `.md` y ninguno es `CLAUDE.md` ni está bajo `.claude/` o `.github/`. Cualquier otro caso es `full`. No hay camino parcial: decide el script, no el criterio de nadie.

```text frame="terminal" title="camino corto"
implement-issue -> scripts/loop-path.sh -> ship
```

## Camino completo

1. `review-changes` corre una vez, sobre el diff contra `origin/main` más lo que no está commiteado.
2. `verify-findings` corre solo si la revisión reporta hallazgos BLOCKING o IMPORTANT.
3. `implement-issue` en modo fix corrige lo que `verify-findings` confirmó, en un solo ciclo.

No hay segunda revisión. Los menores que queden abiertos se listan en el cuerpo del PR como registro, y nadie los revisa antes del merge.

## Fuentes

- [Subagents](https://code.claude.com/docs/en/sub-agents)
