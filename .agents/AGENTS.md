# Agent Instructions and Context: shiny-agro-maices

This repository contains the Shiny application for the Proyecto Global de Maíces (PGM) by CONABIO.

## Key Information

- **Technology Stack**: This is an R-based Shiny application (`global.R`, `ui.R`, `server.R`).
- **Deployment**: The application must be deployed and run using Docker or Podman.
- **Local Development & Running**:
  - Use `podman compose up --build -d` (or `docker compose up --build -d`) to build and run the application container.
  - The application inside the container expects paths relative to `/srv/shiny-server/`.
  - Make sure that directories containing necessary application assets (such as `data`, `extra_files`, `www` or `www/js`) are NOT excluded by `.dockerignore` unless they are mounted dynamically. Data files are read as `./data/<file>`.
  - To check if the application is running, visit `http://localhost:3838` (or the port specified in `docker-compose.yml`, set with `PGMAICES_EXTERNAL_PORT`).
  - To stop the application, use `podman compose down -v` (or `docker compose down`).
  - The project uses `renv`: `.Rprofile` switches to the project library. If R reports a package as missing that is installed on the system, use `renv::hydrate()` — do not reinstall it. `renv` is not used inside the container; `scripts/install_reqs.sh` installs the packages there.
- **Before changing anything**, read `informacion_adicional.md`. It documents failures that produce no visible error, in the Shiny log or the browser console, and so cannot be found by reading the code.
