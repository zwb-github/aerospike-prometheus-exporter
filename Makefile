# Variables required for this Makefile
ROOT_DIR = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VERSION = $(shell git describe --tags --always)

# Builds exporter binary
.PHONY: exporter
exporter:
	go build -ldflags="-X 'main.version=$(VERSION)'" -o aerospike-prometheus-exporter .

# Builds RPM, DEB and TAR packages
# Requires FPM package manager
.PHONY: deb
deb: exporter
	$(MAKE) -C $(ROOT_DIR)/pkg/ $@

.PHONY: rpm
rpm: exporter
	$(MAKE) -C $(ROOT_DIR)/pkg/ $@

.PHONY: tar
tar: exporter
	$(MAKE) -C $(ROOT_DIR)/pkg/ $@

# Clean up
.PHONY: clean
clean:
	rm -rf aerospike-prometheus-exporter
	$(MAKE) -C $(ROOT_DIR)/pkg/ $@

# Builds exporter docker image
# Requires docker
.PHONY: docker
docker:
	docker build --build-arg VERSION=$(VERSION) . -t aerospike/aerospike-prometheus-exporter:latest
