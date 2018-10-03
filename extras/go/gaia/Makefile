export GO111MODULE=on

protobuf:
	protoc -I proto proto/agent.proto --go_out=plugins=grpc:agent

build:
	go build
