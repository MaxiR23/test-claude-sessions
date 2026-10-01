---
title: Conexión con GitHub
sidebar:
  order: 3
description: Los dos métodos para conectar una cuenta de Claude con GitHub y qué cambia en cada uno.
---

Las sesiones en la nube necesitan GitHub para clonar repos y pushear ramas. Hay dos formas documentadas de conectar la cuenta de Claude.

| Método | Cómo se conecta | Repos a los que llegan las sesiones |
| :- | :- | :- |
| **Claude GitHub App** | Autorizás la App durante el onboarding en el navegador, en claude.ai/code | Cualquier repo público, y los privados donde la App esté instalada |
| **`/web-setup`** | Corrés `/web-setup` en el CLI de Claude Code | Cualquier repo al que llegue el token local de `gh`, tenga o no la App instalada |

## Qué dice la documentación de cada método

- **`/web-setup` sincroniza el token local de `gh`.** Lee el token que imprime `gh auth token`, te pide confirmación y lo envía a Anthropic, donde se guarda cifrado junto con la cuenta de claude.ai. Si ya habías conectado GitHub desde el navegador, avisa que seguir reemplaza esa conexión.
- **El alcance depende del método**, como en la tabla. Con la App, un repo privado solo se alcanza si la App está instalada en él. Con `/web-setup`, el alcance es lo que el token de `gh` pueda ver.
- **La App es obligatoria para Auto-fix.** Auto-fix, donde Claude vigila un pull request y responde a fallas de CI y comentarios de revisión, requiere la Claude GitHub App instalada en el repo. Los hilos dentro de un proyecto también la necesitan en cada repo que clonan, sea cual sea el método.
- **La conexión se administra desde la página de conectores.** Desconectar GitHub en claude.ai/customize/connectors borra las credenciales que usan las sesiones, vengan del navegador o de `/web-setup`. Las sesiones pierden el acceso hasta que conectes GitHub de nuevo.

:::caution
Si querés Auto-fix, `/web-setup` no alcanza: necesitás la Claude GitHub App en el repo.
:::

En los dos métodos las credenciales quedan cifradas en los servidores de Anthropic y nunca entran a la VM de la sesión. Las operaciones de GitHub pasan por el proxy que explica [El proxy de GitHub](/configuracion/proxy-github/).

Este repo se conecta con `/web-setup`.

:::note[Observación]
Con la Claude GitHub App, los eventos de etiquetas y de asignado aparecían en el timeline del PR con el sufijo "with Claude".
:::

:::note[Observación]
Después de conectar GitHub con `/web-setup` en lugar de la App, esos mismos eventos aparecieron sin el sufijo "with Claude".
:::

Sobre por qué no se usa un `GH_TOKEN` propio, mirá [Variables de entorno](/configuracion/variables-de-entorno/).

## Fuentes

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Get started with Claude Code in the cloud](https://code.claude.com/docs/en/web-quickstart)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
