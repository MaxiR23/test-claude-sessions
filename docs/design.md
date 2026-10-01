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
| `--color-accent` | `#F0B44C` | Links, primary action, site title cursor, card numbers, eyebrow, focus ring |
| `--color-tip` | `var(--color-accent)` | Tip aside tone (warm) |
| `--color-tip-bg` | `color-mix(in srgb, var(--color-accent) 12%, var(--color-surface))` | Tip aside background |
| `--color-danger` | `#F2706A` | Caution aside tone (red) |
| `--color-danger-bg` | `color-mix(in srgb, var(--color-danger) 12%, var(--color-surface))` | Caution aside background |
| `--color-accent-bg` | `color-mix(in srgb, var(--color-accent) 15%, var(--color-bg))` | Accent-low surfaces, e.g. selected sidebar item |

### Typography

| Token | Value | Role |
| --- | --- | --- |
| `--font-mono` | `'JetBrains Mono', monospace` | Headings, site title, code, terminal block, eyebrow, card numbers |
| `--font-body` | `'IBM Plex Sans', sans-serif` | Everything else |

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

### Light theme

Starlight's default light palette is kept. The tokens apply to the dark
theme; fonts apply to both.

## 2. Usage rules

- No color, font, size or spacing literal outside
  `site/src/styles/tokens.css`. Components use tokens, or Starlight
  variables that the tokens map onto.
- Allowed literals: `0`, `100%`, `fr`, `ch`, viewport units inside
  `clamp()`, and the two breakpoints inside `@media`.
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

### Card

Starlight `Card` inside `CardGrid`, imported from
`@astrojs/starlight/components` in an `.mdx` page. Numbered cards put
`<span class="card-number">01</span>` at the start of the `title`. Use it
for parallel entry points, such as guide chapters. Do not use it for
sequential steps: use Starlight `Steps`.

### Callout

Starlight asides. `:::tip` (warm accent tone) for advice that saves time;
`:::caution` (red tone) for things that break or lose work; `:::note` for
neutral context. `:::danger` keeps Starlight's default.

### Overrides

- Hero with eyebrow: `site/src/components/Hero.astro`
- Site title (`~/name_` form): `site/src/components/SiteTitle.astro`
- Footer with back-to-top button: `site/src/components/Footer.astro`

## 4. Responsive rules

- Breakpoints: `50rem` (md) and `72rem` (lg), the same as Starlight. No
  others.
- Mobile first, minimum width 360 px with no horizontal scroll.
- Hero: stacks centered below md, aligns start at md and up.
- CardGrid: one column below md, two at md and up.
- Terminal block: scrolls horizontally inside its own frame, never the
  page. Keep lines under 60 characters.
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

- Touch targets at least `--size-touch` (44 px): hero actions and the
  back-to-top button.
- Visible focus: every focusable element shows a `--focus-ring-width` solid
  `--color-accent` outline on `:focus-visible`.
- Icon-only controls carry an accessible label (back-to-top: `Volver
  arriba`).
- Decorative text (the site title's `~/` form) is `aria-hidden`, with the
  real title exposed to assistive tech.
