# newsletter-margotbrun — frozen static archive

A **frozen, plain-HTML archive** of `newsletter.margotbrun.com`, served by a current
`nginx:alpine`. It is **not** the original React single-page app — the SPA was
converted to static HTML once and is never rebuilt.

Upstream source: [github.com/MargotBrun/newsletter-kiwi](https://github.com/MargotBrun/newsletter-kiwi)
(Create React App, React 16, `react-scripts` 1.1.5).

## What's served

Clean routes map to static files (see `nginx.conf`):

| Route                        | File                          | Notes |
|------------------------------|-------------------------------|-------|
| `/`                          | `index.html`                  | Subscription page (form inert — frozen) |
| `/desinscription`            | `desinscription.html`         | Unsubscription page (form inert) |
| `/politique-confidentialite` | `politique-confidentialite.html` | Privacy policy |
| `/liste`                     | `liste.html`                  | 11 newsletter cards (links to Sendinblue) |
| `/pictures`                  | `pictures.html`               | Photo-albums notice |
| `/quiz`                      | `quiz.html`                   | **Rebuilt** — interactive, pure CSS |
| `/oiseaux`                   | `oiseaux.html`                | **Rebuilt** — audio + click-to-open video popup |

Unknown paths return a real `404` (no SPA fallback).

## How it was produced

The two interactive pages could not be faithfully snapshotted from the running SPA,
so they were **rebuilt from source** as static HTML; the rest were reconstructed from
the same component markup. All pages reuse the project's original compiled stylesheet
(`static/css/main.css`) with its literal class names, so they look identical to the SPA.

- **`/quiz`** — the original revealed answers via React state on radio-click. The
  rebuild keeps the exact original markup (radio inside label) and reveals the matching
  answer with a pure-CSS `:has()` selector. **No JavaScript.**
- **`/oiseaux`** — rebuilt from source (the YouTube video only ever rendered inside a
  click-opened popup, so it could not be snapshotted). Keeps the original look and
  behaviour: native `<audio controls>` bird calls, and a click-to-open video popup
  driven by a small vanilla-JS handler (the iframe `src` is only set on open, so no
  video loads until a bird is clicked, and is cleared on close). This is plain DOM JS
  for a popup — not app rendering.

### Self-contained assets

The archive has **no external runtime dependencies** (the original loaded Bootstrap,
Google Fonts, jQuery and Google Analytics from CDNs):

- `static/css/main.css` — the app's own compiled CSS (copied from the CRA build).
- `static/vendor/bootstrap.min.css` — Bootstrap 4.3.1, vendored locally.
- `static/vendor/fonts.css` + `static/vendor/fonts/*.woff2` — Domine & Open Sans,
  vendored locally.
- `static/media/*` — images and `.mp3` bird calls (from the CRA build; small nav icons
  copied from source since CRA inlined them).
- `images/background*.png` — the page background.

jQuery and Google Analytics were intentionally dropped.

## Build & run

```sh
docker build -t ghcr.io/paulintrognon/newsletter-margotbrun:latest .
docker run --rm -p 8080:80 ghcr.io/paulintrognon/newsletter-margotbrun:latest
# open http://localhost:8080/
```

## Hosting

The image is pushed to `ghcr.io/paulintrognon/newsletter-margotbrun`. Hosting on the
k3s cluster (k8s manifests + Argo CD Application) is handled in the separate
`paulin/infra` repository.
