DOCKER_OWNER := notyim
DOCKER_REPO  := notyim
GIT_COMMIT   ?= $(shell git rev-parse --short HEAD)
DOCKER_TAG  := ${DOCKER_OWNER}/${DOCKER_REPO}:${GIT_COMMIT}
DOCKER_LATEST  := ${DOCKER_OWNER}/${DOCKER_REPO}:latest

d := docker
df := -f extras/docker/Dockerfile

runall:
	overmind start

webpack:
	bin/webpack-dev-server --profile --color

server:
	bin/rails s

worker:
	bundle exec sidekiq

console:
	bin/rails c

docker: docker-web docker-app
	docker push ${DOCKER_TAG}-web
	docker push ${DOCKER_TAG}-app

docker-web:
	$(d) build $(df) -t ${DOCKER_TAG}-web --target web .

docker-app:
	$(d) build $(df) -t ${DOCKER_TAG}-app --target app .

up:
	docker-compose up --abort-on-container-exit  --remove-orphans

lint:
	bundle exec rubocop

mongo-shell:
	mongo trinity_development

flux-shell:
	influx -database noty_development
