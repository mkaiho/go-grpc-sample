FROM debian:bullseye

ARG GO_GILE=go1.17.1.linux-amd64.tar.gz
ARG SRC_MODULE=github.com/mkaiho/go-grpc-sample
ARG AWSCLI_VERSION=2.2.5

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN groupadd -r devusers && useradd -r -g devusers devuser

RUN apt-get update && apt-get install -y \
  make curl git protobuf-compiler gnupg software-properties-common unzip

RUN curl -OL https://golang.org/dl/${GO_GILE} \
  && tar -C /usr/local -xzf ${GO_GILE} \
  && rm ${GO_GILE}

RUN mkdir -p $GOPATH/src/$SRC_MODULE && chmod -R 777 $GOPATH

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 \
  && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip -o "awscliv2.zip" \
&& unzip awscliv2.zip \
&& ./aws/install \
&& rm -i awscliv2.zip

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
&& apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
&& apt-get update && apt-get install terraform \
&& terraform --version

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
  && apt-get update \
  && apt-get install -y ansible

WORKDIR $GOPATH/src/$SRC_MODULE
