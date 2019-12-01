DOCKER_OWNER := notyim
DOCKER_REPO  := trinity
GIT_COMMIT   ?= $(shell git rev-parse --short HEAD)
DOCKER_TAG  := ${DOCKER_OWNER}/${DOCKER_REPO}:${GIT_COMMIT}
DOCKER_LATEST  := ${DOCKER_OWNER}/${DOCKER_REPO}:latest

d := docker

runall:
	overmind start

webpack:
	bin/webpack-dev-server --profile --color

rails:
	bin/rails s

console:
	bin/rails c

docker:
	$(d) build -t ${DOCKER_TAG} .

lint:
	bundle exec rubocop
