FROM golang:1.11.5-stretch

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
    apt-transport-https \
    git \
    gettext-base \
    curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash kube
RUN echo 'kube:password' | chpasswd

ENV GOPATH /go

ADD config.yml.tpl /var/opt/
ADD entrypoint.sh /var/opt/
RUN chown kube:kube /var/opt/config.yml.tpl && \
    chown kube:kube /var/opt/entrypoint.sh

USER kube

RUN set -ex && \
    go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator

WORKDIR /var/opt

