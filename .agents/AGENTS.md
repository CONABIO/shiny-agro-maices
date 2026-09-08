# Agent Instructions and Context: shiny-agro-maices

This repository contains the Shiny application for the Proyecto Global de Maíces (PGM) by CONABIO.

## Key Information

- **Technology Stack**: This is an R-based Shiny application (`global.R`, `ui.R`, `server.R`).
- **Deployment**: The application must be deployed and run using Docker or Podman. It is no
  longer published to shinyapps.io.
- **Local Development & Running**:
  - Use `podman compose up --build -d` (or `docker compose up --build -d`) to build and run the application container.
  - The application inside the container expects paths relative to `/srv/shiny-server/`.
  - Data files live in `data/`; the code reads them as `./data/<file>`. Sources that the app
    does not read at runtime live in `extra_files/`.
  - Make sure that directories containing necessary application assets (such as `data`, `www`
    and `www/js`) are NOT excluded by `.dockerignore` unless they are mounted dynamically.
  - The external port is set with the `PGMAICES_EXTERNAL_PORT` environment variable and
    defaults to 3838. To check if the application is running, visit `http://localhost:3838`.
  - To stop the application, use `podman compose down -v` (or `docker compose down`).

## ⚠️ Before changing anything, read `informacion_adicional.md`

That document records failures that produce **no visible error** — not in the Shiny log, not
in the browser console — and therefore cannot be found by reading the code. The most
important ones:

- **The locale must be UTF-8.** Outside a UTF-8 locale, R does not consider the accented
  literals in `global.R` equal to the values coming from the `.xlsx`, even when the bytes are
  identical: the map silently loses 52.5% of its colours. `global.R` opens with a block that
  promotes the locale, and the `Dockerfile` sets `LANG`/`LC_ALL`. Do not remove either.
- **The basemap is Esri, not CartoDB.** CARTO stamps "API KEY REQUIRED" onto its free tiles,
  which still return HTTP 200, so nothing fails loudly. Esri needs two layers plus
  `maxNativeZoom = 16`.
- **`levels()` on a `character` column returns `NULL`** and silently produces empty
  selectors. Use `sort(unique(x))`.
- **D3 charts must not rebuild their SVG** on resize, and `exit()` must remove immediately
  without a transition; otherwise they flicker and eventually go blank.
- **The map palette is deliberate.** Do not "fix" `RatingCol` or recolour by racial complex.

## Verification

```bash
# Full check: locale, colours, state matching and selector contents
LC_ALL=C Rscript --vanilla -e 'source("global.R"); sum(!grepl("^#[0-9A-Fa-f]{6}$", TableL$RatingCol))'   # must print 0
```

Section 9 of `informacion_adicional.md` lists the rest of the pre-release checks, including
what to look at in the browser (in an incognito window, to bypass the tile cache).
