---
title: Merge
sidebar:
  order: 7
description: Cómo la skill ship mergea el PR con merge.sh.
---

Después de `publish` y del retiro del pie, la skill `ship` mergea solo con `scripts/merge.sh <pr>`.

:::caution
Nunca mergees de otra forma: ni `gh pr merge`, ni la interfaz web, ni otra llamada a la API.
:::

## Qué exige el script

- El PR abierto, con base en `main`, mergeable y sin checks fallando.
- Que el status requerido `Vercel` (`REQUIRED_STATUS` en el script) esté reportado y exitoso: espera hasta que lo esté.

## Qué hace

Hace squash por la API REST con `<título del PR> (#<N>)` como título. Squash es el único método habilitado en la configuración del repo. Al terminar imprime `verified` y `reason` del commit de merge, y la sesión los reporta.

El commit de squash lo firma GitHub y llega a `main` como un solo commit con el título del PR y el número.

La sesión nunca ofrece vigilar el PR.

## Fuentes

- [Merge a pull request](https://docs.github.com/en/rest/pulls/pulls#merge-a-pull-request)
- [Configuring commit squashing for pull requests](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests)
