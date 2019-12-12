FROM golang as builder

WORKDIR /app

ADD . /app

RUN cd /app/cmd/server && go build -o /app/gaia-server && \
    cd /app/cmd/client && go build -o /app/gaia-client

# final stage
FROM debian:buster-slim
WORKDIR /app

COPY --from=builder /app/gaia-server /usr/bin/gaia-server

ENTRYPOINT /usr/bin/gaia-server
