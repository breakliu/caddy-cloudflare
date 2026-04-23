# caddy-cloudflare

Build a Caddy image bundled with the [Cloudflare DNS plugin](https://github.com/caddy-dns/cloudflare).

## Quick start

```bash
make build            # -> caddy-cloudflare:local
make verify           # sanity-check plugin is embedded
```

## Use in docker-compose

```yaml
services:
  caddy:
    image: caddy-cloudflare:local   # built by `make build`
    # or build inline:
    # build:
    #   context: ../caddy-cloudflare
    environment:
      - CF_API_TOKEN=${CF_API_TOKEN}
    # ...
```

## Pin a specific Caddy version

```bash
make build CADDY_VERSION=2.9.0 TAG=2.9.0
```

See `make help` for all options.
