# Maya Web

A **Mayan Tzolkin kin calculator** in the browser — a PureScript port of the original [Haskell library](https://github.com/gustavoguichard/maya), compiled to a single static JavaScript bundle and deployable for free on any static host.

Enter a date, see the kin, its wavespell, its relationships (guide, analog, antipode, hidden), and its earth family.

## Setup

Requires Node.js 20+. Install the toolchain (PureScript compiler, Spago, esbuild):

```bash
npm install
```

## Build

```bash
npm run build
```

Bundles `src/Facade.purs` (and everything it pulls in) into a single ES module at `public/maya.js`, consumed directly by `public/index.html` via `<script type="module">`.

## Develop

```bash
npm run dev
```

Starts a local HTTP server at http://localhost:3000 serving `public/`. ES modules need http:// — opening `index.html` via `file://` will fail.

Rebuild in one tab, refresh in the other.

## Test

```bash
npm test
```

Runs the PureScript test suite (`test/`) with [purescript-spec](https://github.com/purescript-spec/purescript-spec). Covers diff direction, 2012-12-21 baseline, Feb 29 null-day collapse, and tzolkin length invariants.

## Deploy

Everything the site needs is inside `public/`. Any static host works:

- **Vercel** — `vercel deploy public/` (or connect the repo with output directory `public/` and build command `npm run build`).
- **Netlify** — `netlify deploy --dir public --prod`.
- **Cloudflare Pages** — connect the repo with build command `npm run build`, output directory `public/`, Node 20+.

No backend, no runtime, no env vars — the kin calculation runs entirely in the browser.

## Project layout

| Path | Role |
|------|------|
| `src/Helpers.purs` | `cycleIndex`, `elemPos` — array helpers that replace Haskell's custom `!!<` / `!!?` operators. |
| `src/Kins.purs` | `Selo` / `Tom` / `Cor` / `Kin` types and every kin-relationship function. |
| `src/Maya.purs` | Gregorian-date → kin-number logic, including Dreamspell Feb 29 null-day handling. |
| `src/Facade.purs` | Single JS-friendly entry point `kinInfo` returning a flat record of strings and ints. |
| `test/*.purs` | Golden-case tests. |
| `public/index.html` | Inline static page — form, result view, `<script type="module">`. |
| `public/maya.js` | Built bundle (gitignored). |

## JS API

After building, `public/maya.js` exposes:

```js
import { kinInfo } from './maya.js';

const info = kinInfo({ year: 2012, month: 12, day: 21 });
// {
//   number: 53,
//   name: "Noite Harmonico Azul",
//   seal: "Noite",
//   tone: "Harmonico",
//   color: "Azul",
//   guide: "...", analog: "...", antipode: "...", hidden: "...",
//   wavespell: [ "...", ... 13 entries ... ],
//   family: [ "Seal1", "Seal2", "Seal3", "Seal4" ]
// }
```

All fields are JS-native primitives or arrays of strings — no PureScript runtime types cross the boundary.

## Notes on the port

The PureScript code is a near-mechanical translation of the three Haskell source files:

- `[a]` → `Array a`
- Haskell's `deriving (Eq, Ord, Show)` → `derive instance` plus `genericShow` for `Show`.
- `[Dragao .. Sol]` (Bounded/Enum) → explicit array literals — simpler than wiring up `Generic` cardinality.
- `Data.Time.Day` + `diffDays` → `Data.Date.Date` + `diff` (returns `a - b`, matching the Haskell convention).
- `Data.Int.round` converts the `Days Number` diff back to `Int` (whole-day diffs are always integral).
- Custom `!!<` and `!!?` operators are replaced by named helpers in `Helpers.purs`.

Arithmetic stays in `Int`. Day magnitudes for any human timeframe fit inside `Int32`. PureScript's `EuclideanRing Int` `mod` is non-negative, matching Haskell's `mod` semantics.

## Dreamspell notes

This implements the **Dreamspell** system (José Argüelles), not the traditional Mayan Tzolkin. Feb 29 is a "null day" — it does not advance the kin count, so Feb 29 and Mar 1 always share the same kin.

Leap year detection follows full Gregorian rules (divisible by 4, except centuries, unless also divisible by 400). Years like 1900 and 2100 are correctly treated as non-leap. Since the Dreamspell is based on the Gregorian calendar (introduced in 1582), dates far in the past use proleptic Gregorian rules and should be taken as mathematical extrapolations rather than historically precise kins.
