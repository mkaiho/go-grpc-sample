OUT_DIR := ./build
OUT_BIN_NAME := main

build:
	@go build -o $(OUT_DIR)/$(OUT_BIN_NAME)

clean:
	@rm -r $(OUT_DIR)
