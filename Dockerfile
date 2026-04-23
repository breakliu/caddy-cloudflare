# syntax=docker/dockerfile:1.6
#
# Caddy with Cloudflare DNS plugin
# - Stage 1: use official builder image + xcaddy to compile a caddy binary with the plugin
# - Stage 2: copy the binary into the slim alpine runtime
#
# Build:
#   docker build -t caddy-cloudflare:local .
# Or via Makefile:
#   make build

ARG CADDY_VERSION=2.11

FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Sanity check: fail the build if the plugin is not present
RUN caddy list-modules | grep -q '^dns.providers.cloudflare$'

