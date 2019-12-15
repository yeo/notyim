FROM golang as builder

WORKDIR /app
RUN  curl -sfL https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh

ADD . /app
ADD .goreleaser.yml /app


RUN /app/bin/goreleaser --snapshot --rm-dist

# final stage
FROM debian:buster-slim
WORKDIR /app

COPY --from=builder /app/dist/server_linux_amd64/gaia-server /usr/bin/gaia-server

ENTRYPOINT /usr/bin/gaia-server
