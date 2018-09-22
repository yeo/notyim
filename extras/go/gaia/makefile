GITHUB_USER=notyim
GITHUB_REPO=gaia
DESCRIPTION=$(shell sh -c 'git log --pretty=oneline | head -n 1')
NAME=gaia
ITERATION=2

UNAME := $(shell sh -c 'uname')
VERSION := $(shell sh -c 'git describe --always --tags')
CURRENT_VERSION := $(shell sh -c 'git rev-parse --short HEAD')
PRODUCTION_PATH=/var/app/gaia/bin/gaia

ifdef GOBIN
	PATH := $(GOBIN):$(PATH)
else
	PATH := $(subst :,/bin:,$(GOPATH))/bin:$(PATH)
endif

# Standard Gaia build
default: prepare build

# Only run the build (no dependency grabbing)
build:
	go build -o gaia -ldflags \
		"-X main.Version=$(CURRENT_VERSION)" \
		./main.go

run_server:
	source ./dotenv && ./gaia server
run_client:
	source ./dotenv && ENV=LOCAL GAIA_SERVER_HOST=http://127.0.0.1:28300 ./gaia client
run_client2:
	source ./dotenv && ENV=LOCAL GAIA_SERVER_HOST=http://192.168.1.112:28300 ./gaia client

# Build with race detector
dev: prepare
	go build -race -o gaia -ldflags \
		"-X main.Version=$(VERSION)" \
		./main.go

# Build linux 64-bit, 32-bit and arm architectures
build-linux-bins: prepare
	GOARCH=amd64 GOOS=linux go build -o gaia_linux_amd64 \
				 -ldflags "-X main.Version=$(CURRENT_VERSION)" \
				 ./main.go

# Get dependencies and use gdm to checkout changesets
prepare:
	brew install gnu-tar
	gem install fpm
	#go get ./...

sync:
	rsync -azvp --exclude '.git' --exclude '*.go' . p-axcoto:gaia

adhoc:
	ssh axcoto "cd gaia; ./run_linux.sh"

test-short:
	go test -short ./...

.PHONY: test-short

deploy: build push

github-release:
	github-release release \
		--user $(GITHUB_USER) \
		--repo $(GITHUB_REPO) \
		--tag $(CURRENT_VERSION) \
		--name "RELEASE $(CURRENT_VERSION)" \
		--description "$(DESCRIPTION)"

	github-release upload \
		--user $(GITHUB_USER) \
		--repo $(GITHUB_REPO) \
		--tag $(CURRENT_VERSION) \
		--name "gaia-linux" \
		--file gaia_linux_amd64

upload-package:
	github-release upload \
		--user $(GITHUB_USER) \
		--repo $(GITHUB_REPO) \
		--tag $(CURRENT_VERSION) \
		--name "gaia_amd64.deb" \
		--file packaging/output/systemd/gaia_0.1-$(CURRENT_VERSION)-$(ITERATION)_amd64.deb

build-deb-systemd: build
	# gem install fpm
	fpm -s dir -t deb -n $(NAME) -v 0.1-$(CURRENT_VERSION) -p packaging/output/systemd \
		--deb-priority optional --category admin \
		--deb-compression bzip2 \
	 	--after-install packaging/scripts/postinst.deb.systemd \
		--url https://noty.im \
		--description "Application infrastructure monitoring" \
		-m "Noty <vinh@noty.im>" \
		--iteration $(ITERATION) --license "GPL 3.0" \
		--vendor "Noty" -a amd64 \
		gaia_linux_amd64=/usr/bin/gaia \
		packaging/root/=/
clean_deb:
	rm -rf packaging/output/systemd/*.*

package: clean_deb build-deb-systemd upload-package

clean-influx:
	echo "Clean influxdb"

release: build-linux-bins build-deb-systemd github-release upload-package

# Production task
ssh-deploy:
	ssh noty "sudo systemctl stop gaia; sudo curl -L https://github.com/NotyIm/gaia/releases/download/$(CURRENT_VERSION)/gaia-linux -o $(PRODUCTION_PATH);sudo chmod 700 $(PRODUCTION_PATH); sudo systemctl daemon-reload; sudo systemctl start gaia"
