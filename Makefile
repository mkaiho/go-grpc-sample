OUT_DIR := ./build
OUT_BIN_NAME := main

build:
	@go build -o $(OUT_DIR)/$(OUT_BIN_NAME)

build-example:
	@make build-example-server
	@make build-example-client

build-example-server:
	@go build -o $(OUT_DIR)/example_server ./cmd/example_server

build-example-client:
	@go build -o $(OUT_DIR)/example_client ./cmd/example_client

build-protobuf-go:
	protoc --go_out=. --go-grpc_out=. ./proto/*.proto

clean:
	@rm -r $(OUT_DIR)
