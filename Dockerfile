FROM golang:1.11.5-stretch

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
    apt-transport-https \
    curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash kube
RUN echo 'kube:password' | chpasswd

ENV GOPATH /go

USER kube

RUN set -ex && \
    go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
