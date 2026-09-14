# Small Project No.1 — Go App Behind a Load Balancer

A minimal Go web app, containerized and replicated across 3 instances behind an HAProxy load balancer, all orchestrated with Docker Compose.

## Architecture

```
browser
  │
  ▼
haproxy (:80)  ──round robin──►  app1 (:8080)
  │                              app2 (:8080)
  │                              app3 (:8080)
  ▼
haproxy stats console (:8404/stats)
  ▲
  │ polled every 5s
console container (logs)
```

- **app1 / app2 / app3** — three containers running the same `myapp` image (one Go binary, one Dockerfile, built once and reused).
- **haproxy** — load balances incoming traffic across the three app instances (round robin), and also serves as a service registry console via its stats page.
- **console** — a small dedicated container that polls HAProxy's stats endpoint and prints a live table of each backend's status.

## Running it

```bash
docker compose up -d --build
```

Then:

- **App**: [http://localhost/](http://localhost/) — click "Send request" to see which instance handles each request, or refresh a few times.
- **HAProxy service registry console**: [http://localhost:8404/stats](http://localhost:8404/stats) — login `admin` / `admin` (**demo credentials — change before using this anywhere beyond local testing**). Supports enabling/disabling/draining individual backend servers.
- **Console container's view of the registry**:
  ```bash
  docker compose logs -f console
  ```

Stop everything with:
```bash
docker compose stop
```
or tear it down fully with:
```bash
docker compose down
```

## Image build

The app image is built with a Docker **multistage build** ([Dockerfile](Dockerfile)): a `golang:1.27-alpine` stage compiles a statically linked binary (`CGO_ENABLED=0`), and the final stage is `FROM scratch` — just the binary, no OS, no shell. This keeps the shipped image at roughly 13-14MB.

## Project layout

| Path | Purpose |
|---|---|
| [main.go](main.go) | The Go app — serves `/` (a demo page with a button) and `/api/hit` (returns the responding instance's hostname) |
| [Dockerfile](Dockerfile) | Multistage build for the app image |
| [docker-compose.yml](docker-compose.yml) | Orchestrates app1/app2/app3, haproxy, and console |
| [haproxy.cfg](haproxy.cfg) | Load balancing + stats console configuration |
| [console/](console) | A small container that polls and prints HAProxy's service registry |
| [Makefile](Makefile) | Convenience targets (`make docker-build`, `make docker-run`, etc.) |
