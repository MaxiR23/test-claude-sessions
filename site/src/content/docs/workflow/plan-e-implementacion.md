---
title: Plan e implementación
sidebar:
  order: 3
description: Cuándo hay plan, cómo se implementa y qué es el gate.
---

## Cuándo hay plan

`plan-issue` corre para issues que agregan o cambian comportamiento, una página, un componente o la estructura del sitio. Un typo, un ajuste solo de documentación o un cambio de configuración va directo a `implement-issue`, y el alcance y los criterios de aceptación del issue hacen de plan.

El plan rige tal como está escrito: no hay paso de confirmación.

## Implementar

`implement-issue` lee el plan, no las fuentes que el plan cita, y devuelve el diff stat al terminar.

## Verificar en local: el gate

El gate es el comando que declara `CLAUDE.md`. En este repo es el build del sitio.

```text frame="terminal" title="gate"
pnpm --dir site build
```

`implement-issue` lo corre una sola vez, cuando el plan está implementado. Si falla, corrige y lo vuelve a correr, hasta tres intentos. Después se detiene y reporta. Si `CLAUDE.md` no declara un gate, lo dice y sigue.

## Fuentes

- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Astro CLI reference](https://docs.astro.build/en/reference/cli-reference/)
