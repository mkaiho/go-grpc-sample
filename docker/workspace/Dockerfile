FROM debian:bullseye

ARG GO_GILE=go1.17.1.linux-amd64.tar.gz
ARG SRC_MODULE=github.com/mkaiho/go-grpc-sample

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN groupadd -r devusers && useradd -r -g devusers devuser

RUN apt-get update && apt-get install -y \
  make curl git protobuf-compiler

RUN curl -OL https://golang.org/dl/${GO_GILE} \
  && tar -C /usr/local -xzf ${GO_GILE} \
  && rm ${GO_GILE}

RUN mkdir -p $GOPATH/src/$SRC_MODULE && chmod -R 777 $GOPATH

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 \
  && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

WORKDIR $GOPATH/src/$SRC_MODULE
