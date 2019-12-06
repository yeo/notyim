DOCKER_OWNER := notyim
DOCKER_REPO  := notyim
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

docker: docker-web docker-app
	docker push ${DOCKER_TAG}-web
	docker push ${DOCKER_TAG}-app

docker-web:
	$(d) build -t ${DOCKER_TAG}-web --target web .

docker-app:
	$(d) build -t ${DOCKER_TAG}-app --target app .


lint:
	bundle exec rubocop

mongo-shell:
	mongo trinity_development

flux-shell:
	influx -database noty_development
