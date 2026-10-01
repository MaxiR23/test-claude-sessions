---
title: Introducción
sidebar:
  order: 1
description: Qué hay que preparar para que una sesión de Claude Code en la nube trabaje bien en este repo.
---

Una sesión en la nube arranca desde un clon limpio del repo en una máquina virtual administrada por Anthropic. No hay configuración personal de git, ni tus variables locales, ni tu sesión de `gh`. Todo lo que la sesión necesita tiene que venir del entorno de nube o de archivos que estén commiteados en el repo.

Este capítulo sigue el orden en que se arma la configuración:

1. [Variables de entorno](/configuracion/variables-de-entorno/): la identidad de git con la que se firman los commits.
2. [Conexión con GitHub](/configuracion/conexion-github/): cómo la cuenta de Claude llega a tus repos.
3. [El proxy de GitHub](/configuracion/proxy-github/): qué hace el proxy y qué límites impone.
4. [Atribución](/configuracion/atribucion/): cómo evitar que Claude Code firme commits y PRs.

:::caution
Nunca imprimas, registres ni muestres el valor de una variable de entorno. Vale para tokens, para la identidad y para cualquier otra variable.
:::

Lo que cada página llama observación es algo que vi probando este repo. No está descrito en la documentación oficial y puede cambiar. Va siempre en un recuadro aparte.

## Fuentes

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
