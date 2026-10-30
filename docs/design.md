# Design system

Visual rules for the site in `site/`. The tokens below mirror
`site/src/styles/tokens.css`: a change in one is a change in the other.

## 1. Tokens

### Colors

| Token | Value | Role |
| --- | --- | --- |
| `--color-bg` | `#0F1012` | Page background |
| `--color-surface` | `#17191D` | Nav, sidebar, cards, terminal |
| `--color-border` | `#26282D` | Hairlines, card borders |
| `--color-text` | `#ECEAE4` | Body and headings |
| `--color-text-muted` | `#A3A39C` | Secondary text |
| `--color-accent` | `#F0B44C` | Links, primary action, site title cursor, guide index numbers, eyebrow, hero status line, focus ring |
| `--color-tip` | `var(--color-accent)` | Tip aside tone (warm) |
| `--color-tip-bg` | `color-mix(in srgb, var(--color-accent) 12%, var(--color-surface))` | Tip aside background |
| `--color-danger` | `#F2706A` | Caution aside tone (red) |
| `--color-danger-bg` | `color-mix(in srgb, var(--color-danger) 12%, var(--color-surface))` | Caution aside background |
| `--color-accent-bg` | `color-mix(in srgb, var(--color-accent) 15%, var(--color-bg))` | Accent-low surfaces, e.g. selected sidebar item |
| `--color-accent-shadow` | `color-mix(in srgb, var(--color-accent) 35%, transparent)` | Soft shadow of the primary hero action on hover and focus |

### Typography

| Token | Value | Role |
| --- | --- | --- |
| `--font-heading` | `'Space Grotesk', sans-serif` | Page titles, markdown headings, hero title, eyebrow, guide index numbers and chapter titles |
| `--font-mono` | `'JetBrains Mono', monospace` | Code, terminal block, site title, hero status line, loop flow nodes, guide index link markers, loop flow arrows |
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
| `--size-dot` | 0.3125rem (5 px) | Loop flow connector dot diameter |

### Motion

| Token | Value | Role |
| --- | --- | --- |
| `--duration-flow` | 1.2s | One cycle of the loop flow dot animation |
| `--duration-fade` | 0.2s | Show and hide fade of the back-to-top button |
| `--duration-blink` | 1s | One on/off cycle of the terminal cursors (site title, hero status line) |
| `--duration-enter` | 0.4s | Fade-and-rise of one hero element |
| `--duration-stagger` | 0.1s | Delay between consecutive hero elements |
| `--duration-type` | 0.06s | Time to type one character of the hero status line |
| `--duration-hover` | 0.15s | Hover and focus movement of the hero actions and the guide index links |

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
the accent color at reduced opacity. Use
it where a page needs to show the loop's flow with its branches. Do not
use it for linear steps: use Starlight `Steps`. Do not use it for
commands: use the terminal block.

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

## 4. Responsive rules

- Breakpoints: `50rem` (md) and `72rem` (lg), the same as Starlight. No
  others.
- Mobile first, minimum width 360 px with no horizontal scroll.
- Hero: stacks centered below md, aligns start at md and up.
- Guide index: one column below md, one column per chapter at md and up.
- Terminal block: scrolls horizontally inside its own frame, never the
  page. Keep lines under 60 characters.
- Loop flow: one vertical column at all sizes, with no breakpoint.
  Node text wraps inside its box and never scrolls the page.
- Site title: truncates with `overflow: hidden` instead of wrapping.
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
- Icon-only controls carry an accessible label (back-to-top: `Volver
  arriba`).
- Decorative text (the site title's `~/` form) is `aria-hidden`, with the
  real title exposed to assistive tech.
