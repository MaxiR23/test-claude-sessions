---
title: Recuperación
sidebar:
  order: 8
description: Qué hacer cuando una etapa del loop falla.
---

| Qué falló | Qué hacer |
| :- | :- |
| Tres fallas del gate en `implement-issue`, modo plan | `plan-issue` escribe un addendum desde la salida que falló e `implement-issue` lo implementa. Si esa corrida también falla tres veces, o la falla fue en modo issue o fix, parar y reportar al dueño con la salida |
| `scripts/ship.sh prepare` | Si es sobre el cambio, corregirlo con `implement-issue` en modo fix; si no, seguir el mensaje del script. Después, `prepare` de nuevo |
| `scripts/ship.sh publish` antes del push | Seguir el mensaje del script y volver a `prepare` |
| `scripts/ship.sh publish` después del push y antes de que exista el PR ("branch is pushed but has no open PR") | Reintentar con `publish` |
| Una decisión abierta que levanta `implement-issue` | Si es de producto o de diseño, escribirla en el issue como pregunta BLOCKING y parar el loop en ese issue |

:::caution
Nunca corras `prepare` después del push: reintentá con `publish`.
:::

## Fuentes

- [Subagents](https://code.claude.com/docs/en/sub-agents)
