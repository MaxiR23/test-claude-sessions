# Design system

Visual rules for the site in `site/`. The tokens below mirror
`site/src/styles/tokens.css`: a change in one is a change in the other.

## 1. Tokens

### Colors

| Token | Value | Role |
| --- | --- | --- |
| `--color-bg` | `#0F1012` | Page background |
| `--color-surface` | `#17191D` | Nav, sidebar, cards, terminal |
| `--color-border` | `#26282D` | Hairlines, card borders, loop terminal `↳` of stages not yet done |
| `--color-text` | `#ECEAE4` | Body and headings |
| `--color-text-muted` | `#A3A39C` | Secondary text |
| `--color-accent` | `#F0B44C` | Links, primary action, site title cursor, guide index numbers, eyebrow, hero status line, loop terminal cursor, markers and done stages, focus ring |
| `--color-tip` | `var(--color-accent)` | Tip aside tone (warm) |
| `--color-tip-bg` | `color-mix(in srgb, var(--color-accent) 12%, var(--color-surface))` | Tip aside background |
| `--color-danger` | `#F2706A` | Caution aside tone (red) |
| `--color-danger-bg` | `color-mix(in srgb, var(--color-danger) 12%, var(--color-surface))` | Caution aside background |
| `--color-accent-bg` | `color-mix(in srgb, var(--color-accent) 15%, var(--color-bg))` | Accent-low surfaces, e.g. selected sidebar item |
| `--color-accent-shadow` | `color-mix(in srgb, var(--color-accent) 35%, transparent)` | Soft shadow of the primary hero action on hover and focus |
| `--color-accent-border` | `color-mix(in srgb, var(--sl-color-text-accent) 45%, var(--sl-color-hairline))` | Border of a loop flow stage on hover, following the theme's accent |

### Typography

| Token | Value | Role |
| --- | --- | --- |
| `--font-heading` | `'Space Grotesk', sans-serif` | Page titles, markdown headings, hero title, eyebrow, guide index numbers and chapter titles |
| `--font-mono` | `'JetBrains Mono', monospace` | Code, terminal block, site title, hero status line, loop flow nodes, guide index link markers, loop flow arrows, loop terminal |
| `--font-body` | `'Inter', sans-serif` | Everything else |

Weights: 400 and 600 only.

Size scale: Starlight's `--sl-text-*` scale. No second size scale is
created.

| Token | Value |
| --- | --- |
| `--sl-text-2xs` | 0.75rem |
| `--sl-text-xs` | 0.8125rem |
| `--sl-text-sm` | 0.875rem |
| `--sl-text-base` | 1rem |
| `--sl-text-lg` | 1.125rem |
| `--sl-text-xl` | 1.25rem |
| `--sl-text-2xl` | 1.5rem |
| `--sl-text-3xl` | 1.8125rem |
| `--sl-text-4xl` | 2.1875rem |
| `--sl-text-5xl` | 2.625rem |
| `--sl-text-6xl` | 4rem |

### Spacing

| Token | Value |
| --- | --- |
| `--space-1` | 0.25rem |
| `--space-2` | 0.5rem |
| `--space-3` | 0.75rem |
| `--space-4` | 1rem |
| `--space-5` | 1.5rem |
| `--space-6` | 2rem |
| `--space-7` | 3rem |

### Radii and borders

| Token | Value |
| --- | --- |
| `--radius-sm` | 0.25rem |
| `--radius-md` | 0.5rem |
| `--radius-full` | 999rem |
| `--border-width` | 1px |
| `--border` | `var(--border-width) solid var(--color-border)` |

### Sizes

| Token | Value | Role |
| --- | --- | --- |
| `--size-touch` | 2.75rem (44 px) | Minimum touch target |
| `--focus-ring-width` | 2px | Focus outline width |
| `--size-dot` | 0.3125rem (5 px) | Loop flow connector dot and loop terminal title bar dot diameter |
| `--size-select` | 6.25em | Language select width below md, equal to Starlight's theme select width |

### Motion

| Token | Value | Role |
| --- | --- | --- |
| `--duration-flow` | 1.2s | One cycle of the loop flow dot animation |
| `--duration-fade` | 0.2s | Show and hide fade of the back-to-top button |
| `--duration-blink` | 1s | One on/off cycle of the terminal cursors (site title, hero status line, loop terminal) |
| `--duration-enter` | 0.4s | Fade-and-rise of one hero element or one loop terminal line |
| `--duration-stagger` | 0.1s | Delay between consecutive hero elements |
| `--duration-type` | 0.06s | Time to type one character of the hero status line and the loop terminal command |
| `--duration-type-detail` | 0.015s | Time to type one character of a loop flow detail line |
| `--duration-type-start` | 0.15s | Pause before a loop flow stage starts typing its first line |
| `--duration-type-gap` | 0.09s | Pause between two typed loop flow detail lines |
| `--duration-expand` | 0.3s | Expand and collapse of a loop flow stage, its chevron turn and its link fade-in |
| `--duration-hover` | 0.15s | Hover and focus movement of the hero actions and the guide index links |
| `--duration-run-start` | 0.5s | Pause before the loop terminal starts typing |
| `--duration-run-appear` | 0.22s | Delay between consecutive loop terminal stages appearing |
| `--duration-run-frame` | 0.08s | One frame of the loop terminal spinner |
| `--duration-run-stage-min` | 0.7s | Shortest spinner time of one loop terminal stage |
| `--duration-run-stage-max` | 1.4s | Longest spinner time of one loop terminal stage |
| `--duration-run-pause` | 2.6s | Pause after the final line before the loop terminal repeats |
| `--rotate-open` | 0.5turn | Rotation of the open loop flow chevron |

Every animation is declared inside
`@media (prefers-reduced-motion: no-preference)`; under `reduce` the
element shows its static state.

### Light theme

Starlight's default light palette is kept. The tokens apply to the dark
theme; fonts apply to both.

## 2. Usage rules

- No color, font, size or spacing literal outside
  `site/src/styles/tokens.css`. Components use tokens, or Starlight
  variables that the tokens map onto.
- Allowed literals: `0`, `100%`, `fr`, `ch`, viewport units inside
  `clamp()`, the two breakpoints inside `@media`, percentage offsets as
  keyframe selectors inside `@keyframes`, and unitless `opacity`
  values.
- Only exception: `site/public/favicon.svg`, a static file that cannot read
  CSS custom properties. It repeats `--color-accent` and `--color-bg` as
  literals, mirrored from the tokens.
- Reuse before creating: check Starlight's built-in components first, then
  `site/src/components/`. A new component or token needs a role no existing
  one covers.
- Every change to `site/src/styles/tokens.css` is mirrored here, and vice
  versa.

## 3. Components

### Terminal block

A fenced code block with `frame="terminal"` and a `title` (Expressive Code,
built into Starlight). Use it for commands and session transcripts. Do not
use it for source code: use a normal fenced block with a language.

````md
```text frame="terminal" title="sesión en la nube"
claude --cloud "..."
```
````

### Guide index

`site/src/components/GuideIndex.astro`, imported in `index.mdx` and
placed with a `chapters` prop (folder, title, description per chapter).
One column per chapter, without boxes: the number (`01`, `02`, from the
chapter's position) at `--sl-text-4xl` in the accent heading font, the title,
the description in the muted color, and the chapter's pages as links
preceded by a `›` marker. The page list is generated at build time from
the docs collection: every non-draft page under the folder except
`introduccion`, ordered by `sidebar.order` like the sidebar, with the page
`title` as text; adding, renaming or reordering a page updates it with no
edit to the home. Each link is at least `--size-touch` tall. On hover and
focus a link turns to the accent color and its marker moves `--space-1` to
the right over `--duration-hover`; under reduced motion only the color
changes. Use it for the home's chapter entry points; do not use it for
sequential steps (use Starlight `Steps`).

### Callout

Starlight asides. `:::tip` (warm accent tone) for advice that saves time;
`:::caution` (red tone) for things that break or lose work; `:::note` for
neutral context. `:::danger` keeps Starlight's default.

### Loop flow

`site/src/components/LoopFlow.astro`, imported in an `.mdx` page and
placed as `<LoopFlow />`. An ordered list of the loop's stages, with the
two branches (`loop-path.sh` short path, `review-changes` without
findings) written as text and their arrows hidden from screen readers. Every
stage except the first is preceded by a connector of three
`--size-dot` dots in the accent color, stacked in a column and
`aria-hidden`. The dots fade in one after the other from top to bottom
over `--duration-flow`, in a loop. Under
`prefers-reduced-motion: reduce` they do not animate and stay visible in
the accent color at reduced opacity.

Each stage is a native `<details>` box whose header is its `<summary>`:
the name in mono, an optional note in the muted body font, and at top
right a mono chip with the type (`skill`, `agente`/`agent`, `script`) and a
chevron. `ship` shows its `prepare › publish` chips inside the summary,
always visible. Chips have `--radius-full` corners. Every stage starts
closed in the HTML, with or without JavaScript. On hover a stage's
border turns `--color-accent-border`. The open stage gets the accent
border and accent name, and its chevron turns accent and rotates
`--rotate-open`.

With JavaScript, the script takes over the summary click (and Enter):
only one stage is open at a time, opening one collapses the other, and a
stage expands and collapses over `--duration-expand`. The detail lines,
each after a muted `$`, are in `--font-mono` at `--sl-text-xs` in the
muted color; inline code in them keeps the text color at weight 400.
Each line keeps at least one line of height while it waits. After
`--duration-type-start`, the lines are typed one after the other as
plain text at `--duration-type-detail` per character, with
`--duration-type-gap` between lines and no cursor; each line gets its
formatted markup back as soon as it is typed. Then the link to the
stage's page fades in over `--duration-expand`, in `--font-mono` at
`--sl-text-xs` in the accent color, aligned right; its arrow moves
`--space-1` right on hover and focus over `--duration-hover`. Closing a
stage stops its typing and restores its text. Focusing inside a stage
that is still typing completes it. The script only toggles attributes
and text on elements the component renders, so the scoped styles apply
to every state.

Under reduced motion there is no dot animation, no typing and no
transitions: a stage opens and closes at once, with its full text.
Without JavaScript the stages are plain `<details>`: closed at first,
full text when opened, and several can be open at once.

Use it where a page needs to show the loop's flow with its branches. Do
not use it for linear steps: use Starlight `Steps`. Do not use it for
commands: use the terminal block.

### Loop terminal

`site/src/components/LoopTerminal.astro`, imported in `index.mdx` and
placed as `<LoopTerminal />`. A terminal frame like the terminal block
(surface body, border, title bar with three muted `--size-dot` dots and
the centered title `sesión en la nube` / `cloud session`) that shows one loop run for
issue #24. The run has three phases. Typing: after `--duration-run-start`
the command is typed at `--duration-type` per character, with the `_`
cursor blinking over `--duration-blink`. Stages: they appear
`--duration-run-appear` apart, fading in and rising `--space-2` over
`--duration-enter`, muted with a `·`. Running: each stage shows a braille
spinner at `--duration-run-frame` per frame for a random time between
`--duration-run-stage-min` and `--duration-run-stage-max`, then a `✓`,
the name in the text color and the description in the accent. Then the
final line, a `--duration-run-pause` pause and the repeat. Layout: at md
and up each stage is one line: the marker, the name padded to a column,
and the description. Below md each stage takes two lines: the marker and
the name, then the description aligned with the name and preceded by an
`aria-hidden` `↳` in the border color, which turns muted once the stage
is done. The name is not padded. Below md the text is `--sl-text-code-sm`
and the body padding `--space-2` `--space-3`. At md and up they are
`--sl-text-code` and `--space-3` `--space-4`. It runs only
while visible on screen and the tab is visible. Accessibility: the text
is static in the DOM, the prompt, cursor, markers, `↳` and name padding
are `aria-hidden`, and nothing is announced per cycle. Under reduced motion or without
JavaScript it shows the final state at once and nothing moves. Use it
only for the home's run; for other commands and transcripts use the
terminal block.

### Locales and translations

- The locales are declared once in `site/src/locales.mjs`: Spanish `root`
  (`lang: es`, the default, at the root paths) and English `en` at `/en/`
  with the same slugs.
- Interface strings live in `site/src/content/i18n/es.json` and `en.json`.
  They are read with `Astro.locals.t()` in components and from the same
  files in `astro.config.mjs` (title and sidebar labels).
- No interface string is a literal in `site/src/components/` or
  `astro.config.mjs`. Code (stage names, commands) stays the same in both
  languages.
- English pages live under `site/src/content/docs/en/`, at the same relative path and extension as their Spanish page. A Spanish page without an English copy shows Starlight's fallback on `/en/`.

### Overrides

- Hero with eyebrow: `site/src/components/Hero.astro`. The eyebrow, title,
  tagline, status line and actions fade in and rise `--space-2`, one after
  the other `--duration-stagger` apart, each over `--duration-enter`, once
  on load (0.8 s in total). The status line comes from the `status`
  frontmatter field: `$ ` in the muted color, the text in the accent color
  typed one character per `--duration-type` after the entrance, then a `_`
  that blinks like the site title cursor. On hover and focus the primary
  action rises `--space-1` with a `--color-accent-shadow` shadow, and the
  secondary action turns accent with its arrow moving `--space-1` to the
  right, over `--duration-hover`. Under reduced motion the hero shows at
  once with the status complete and still, the primary keeps only the
  shadow and the secondary only the color.
- Site title (`~/name_` form): `site/src/components/SiteTitle.astro`. The
  `_` cursor blinks once per `--duration-blink` (shared `cursor-blink`
  keyframe in `tokens.css`); still under reduced motion.
- Footer with back-to-top button: `site/src/components/Footer.astro`. The
  button is hidden at the top of the page and appears once the page has
  been scrolled down by more than half the viewport height; scrolling back
  above that point hides it again. While hidden it uses
  `visibility: hidden`, so it is not clickable, not reachable with Tab and
  not exposed to screen readers. It fades in and out over
  `--duration-fade`; under `prefers-reduced-motion: reduce` it shows and
  hides without a transition. Without JavaScript it stays visible.
  Clicking it (or pressing Enter on it) scrolls smoothly to the page title
  (`#_top`); under `prefers-reduced-motion: reduce` it jumps there at once.
  Only this button scrolls smoothly: there is no site-wide
  `scroll-behavior`, so other in-page links still jump. Without JavaScript
  the link jumps to `#_top`.
- Head with language detection: `site/src/components/Head.astro`.
  - A choice stored in `localStorage` (`site-locale`) wins.
  - Otherwise the first entry of `navigator.languages` picks the locale
    with the same primary language. Anything else stays Spanish.
  - A mismatch redirects with `location.replace` to the same slug. Without
    JavaScript there is no redirect.
- Language select: `site/src/components/LanguageSelect.astro`. Starlight's
  select, with the choice stored on change. Without JavaScript it is
  replaced by a `<noscript>` link to the other locale with the `translate`
  icon.

## 4. Responsive rules

- Breakpoints: `50rem` (md) and `72rem` (lg), the same as Starlight. No
  others.
- Mobile first, minimum width 360 px with no horizontal scroll.
- Hero: stacks centered below md, aligns start at md and up.
- Guide index: one column below md, one column per chapter at md and up.
- Terminal block: scrolls horizontally inside its own frame, never the
  page. Keep lines under 60 characters.
- Loop terminal: fits its width with no horizontal scroll down to 360 px.
  Below md the description drops to its own line under the name; at md
  and up each stage is one line with the name padded to a column. Keep
  lines under 40 characters below md.
- Loop flow: one vertical column at all sizes. Below md the note wraps
  under the stage name; at md and up it sits on the name's line. The
  type tag and the chevron always stay at the top right.
  Node text wraps inside its box and never scrolls the page.
- Site title: truncates with `overflow: hidden` instead of wrapping.
- Theme select and language select (Starlight's, header): at md and up their width is set by overriding `--sl-select-width` on the select to `calc(9ch + var(--space-7))` in `tokens.css`, so the longest Spanish label ("Automático") shows in full with its icon and caret. Below md the theme select keeps Starlight's width and the language select uses `--size-select` to equal it; both sit where Starlight places them (the mobile menu).
- Back-to-top button: bottom right with `--space-4` inset at all sizes.
- Relative units only (`rem`, `%`, `ch`, `clamp()`).

## 5. Accessibility minimums

- Text contrast 4.5:1 (3:1 at 24 px and up). Computed ratios:

  | Pair | Ratio |
  | --- | --- |
  | text on bg | 15.82 |
  | text on surface | 14.63 |
  | muted on bg | 7.50 |
  | muted on surface | 6.94 |
  | accent on bg | 10.28 |
  | bg on accent (primary button label) | 10.28 |
  | accent on tip bg | 7.48 |
  | text on tip bg | 11.52 |
  | danger on danger bg | 5.22 |
  | text on danger bg | 12.48 |

- Touch targets at least `--size-touch` (44 px): hero actions, guide index links and the
  back-to-top button.
- Visible focus: every focusable element shows a `--focus-ring-width` solid
  `--color-accent` outline on `:focus-visible`.
- Icon-only controls carry an accessible label (back-to-top:
  `footer.backToTop`, "Volver arriba" / "Back to top").
- Decorative text (the site title's `~/` form) is `aria-hidden`, with the
  real title exposed to assistive tech.
