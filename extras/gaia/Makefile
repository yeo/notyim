version := 0.3.2
commit := $(shell git rev-parse HEAD)
gaia_version := gaia-$(version)
gaia_version_commit := gaia-$(version)-$(commit)
repo := notyim/gaia
d := docker

init-release:
	goreleaser init

docker:
	$(d) build -t $(repo):$(version)-$(commit) .
	$(d) push $(repo):$(version)-$(commit)

github-release:
	goreleaser --snapshot --rm-dist
	ghr $(gaia_version) dist/client_linux_amd64
