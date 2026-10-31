---
title: Merge
sidebar:
  order: 7
description: Cómo se mergea el PR después de revisarlo.
---

El loop termina con el PR abierto y listo para revisar. Una persona lo revisa y, si está bien, lo mergea.

## Qué necesita el PR antes del merge

- Base en `main`, mergeable y sin checks fallando.
- El status requerido `Vercel` reportado y exitoso.

## Cómo

Squash es el único método habilitado en la configuración del repo. El título del commit es `<título del PR> (#<N>)`, y llega a `main` como un solo commit firmado por GitHub.

## Fuentes

- [Merge a pull request](https://docs.github.com/en/rest/pulls/pulls#merge-a-pull-request)
- [Configuring commit squashing for pull requests](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests)
