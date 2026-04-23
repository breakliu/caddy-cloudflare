# Makefile for building the Caddy image bundled with the Cloudflare DNS plugin.
#
# Usage:
#   make build              # build image with default tag
#   make build NO_CACHE=1   # build from scratch (ignore cache)
#   make verify             # run the image once to list the cloudflare plugin
#   make push               # push to a registry (set REGISTRY / IMAGE / TAG)
#   make clean              # remove the local image
#
# Variables can be overridden on the command line, e.g.
#   make build CADDY_VERSION=2.9.0 TAG=2.9.0

CADDY_VERSION ?= 2.11
REGISTRY      ?=
IMAGE         ?= caddy-cloudflare
TAG           ?= local
PLATFORM      ?= linux/amd64

FULL_IMAGE := $(if $(REGISTRY),$(REGISTRY)/,)$(IMAGE):$(TAG)

BUILD_ARGS := --build-arg CADDY_VERSION=$(CADDY_VERSION) --platform=$(PLATFORM)
ifdef NO_CACHE
BUILD_ARGS += --no-cache
endif

.PHONY: help build verify push clean print-image

help:
	@echo "Targets:"
	@echo "  build     Build image $(FULL_IMAGE) (CADDY_VERSION=$(CADDY_VERSION))"
	@echo "  verify    Run the image once and check that the cloudflare plugin is present"
	@echo "  push      docker push $(FULL_IMAGE)"
	@echo "  clean     docker rmi $(FULL_IMAGE)"
	@echo ""
	@echo "Overridable variables:"
	@echo "  CADDY_VERSION=$(CADDY_VERSION)"
	@echo "  REGISTRY=$(REGISTRY)"
	@echo "  IMAGE=$(IMAGE)"
	@echo "  TAG=$(TAG)"
	@echo "  PLATFORM=$(PLATFORM)"
	@echo "  NO_CACHE=(unset)    set to 1 to force --no-cache"

build:
	docker build $(BUILD_ARGS) -t $(FULL_IMAGE) .

verify:
	@echo "Listing caddy modules matching cloudflare..."
	docker run --rm --entrypoint caddy $(FULL_IMAGE) list-modules | grep cloudflare || \
		(echo "cloudflare plugin NOT found in $(FULL_IMAGE)" && exit 1)

push:
	@test -n "$(REGISTRY)" || (echo "REGISTRY is required for push" && exit 1)
	docker push $(FULL_IMAGE)

clean:
	-docker rmi $(FULL_IMAGE)

print-image:
	@echo $(FULL_IMAGE)

