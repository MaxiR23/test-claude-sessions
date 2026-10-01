---
title: El proxy de GitHub
sidebar:
  order: 4
description: Cómo pasan las operaciones de GitHub por el proxy de las sesiones en la nube y qué límites tiene.
---

En los entornos alojados por Anthropic, todas las operaciones de GitHub pasan por un proxy dedicado que mantiene las credenciales reales fuera de la VM. Aplica sin importar el nivel de acceso a la red del entorno.

## `gh` y el placeholder `proxy-injected`

El CLI `gh` viene preinstalado en las sesiones y lee `GH_TOKEN` solo, así que nunca hace falta `gh auth login`. Cuando no hay `GH_TOKEN` ni `GITHUB_TOKEN` en el entorno, las dos variables valen el texto `proxy-injected` dentro de la sesión y el proxy sustituye las credenciales reales en los pedidos salientes a GitHub.

:::caution
`gh` funciona en ese caso, pero un script que lea la variable directamente obtiene el placeholder, no un token usable.
:::

## REST en lugar de GraphQL

El proxy atiende solo un conjunto fijo de operaciones GraphQL para flujos de pull requests y rechaza todo lo demás con un 403 que nombra la alternativa REST: `gh api repos/{owner}/{repo}/...`. La restricción vale para todos los pedidos que pasan por el proxy, con cualquier credencial, así que un `GH_TOKEN` en el entorno recibe el mismo 403.

Varios subcomandos de `gh` usan GraphQL por debajo: `gh pr list`, `gh pr view` y `gh repo view`, entre otros. Por eso `scripts/ship.sh`, `scripts/issue.sh` y `scripts/merge.sh` leen por REST, y `scripts/ship.sh` solo recurre a la API REST cuando falla `gh pr create` o `gh pr edit`.

:::tip
Para leer un issue sin GraphQL, usá la forma REST:

```text frame="terminal" title="leer un issue por REST"
gh api repos/[USUARIO]/[REPO]/issues/[N]
```
:::

## Otras reglas del proxy

- **Protección de push.** `git push` a través del proxy funciona solo contra la rama de trabajo actual de la sesión. Clonar, hacer fetch y operar sobre pull requests funciona normal.
- **Alcance por repo.** Los pedidos a la API de GitHub llegan solo a los repos adjuntos a la sesión. Cualquier otro repo recibe un 403.

:::note[Observación]
A la sesión se le indica pushear a una rama `claude/...`, pero `scripts/ship.sh` pushea la rama `type/short-description` que creó. El push funcionó igual.
:::

:::note[Observación]
Renombrar un repo rompe `gh api` a través del proxy. Una sesión clonada con el nombre anterior resuelve los placeholders con ese nombre, GitHub responde con una redirección a una ruta con ID numérico y el proxy rechaza esa ruta con un 403. Con el nombre nuevo también hay 403 si la sesión no tiene adjunto el repo con ese nombre. `git fetch` y `git push` con el nombre anterior siguieron andando. Las llamadas a `gh api` quedaron rotas hasta que se adjuntó el repo a la sesión con el nombre nuevo.
:::

## Fuentes

- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
- [REST API: issues](https://docs.github.com/en/rest/issues/issues)
- [REST API: pull requests](https://docs.github.com/en/rest/pulls/pulls)
