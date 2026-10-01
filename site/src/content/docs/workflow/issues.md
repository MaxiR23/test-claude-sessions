---
title: Issues
sidebar:
  order: 2
description: Cómo se escribe un issue para que el loop pueda trabajar sobre él.
---

Todo cambio empieza en un issue.

- **Título**: `type: descripción corta`, en minúsculas, una línea, sin punto final. `scripts/issue.sh` lo arma desde el tipo y la descripción.
- **Tipos permitidos**: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`, `perf`, `ci`, `build`.
- **Etiqueta**: exactamente una, igual al tipo. `scripts/ship.sh` toma el tipo de la rama desde la etiqueta y el mensaje de commit desde el título.
- **Cuerpo**: `## Scope`, `## Out of scope`, `## Acceptance criteria` (como casillas) y `## Open questions` solo si las hay, cada una marcada BLOCKING o DEFERRABLE.

```text title="título de ejemplo"
docs: write the setup and workflow guide
```

La skill `create-issue` lo redacta y lo crea con `scripts/issue.sh`. La skill `refine-issue` completa las secciones que falten de un issue existente. Un issue que ya tiene las tres secciones no se refina.

Los issues se crean solo con `scripts/issue.sh`, nunca con `gh issue create`, que usa GraphQL y el proxy lo bloquea. Ver [El proxy de GitHub](/configuracion/proxy-github/).

:::tip
Congelá el alcance: el alcance es el cuerpo del issue cuando arranca el loop. Lo que aparece a mitad de camino es un issue nuevo, no una ampliación del que está corriendo.
:::

:::caution
Una pregunta BLOCKING frena el loop en ese issue hasta que la respuesta esté escrita en el issue. Nada se planifica sobre una suposición.
:::

## Fuentes

- [REST API: issues](https://docs.github.com/en/rest/issues/issues)
- [Skills](https://code.claude.com/docs/en/skills)
