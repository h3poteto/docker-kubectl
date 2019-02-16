FROM golang:1.11.5-stretch

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
    apt-transport-https \
    git \
    gettext-base \
    zip \
    curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/opt/kube

RUN useradd -m -s /bin/bash kube
RUN echo 'kube:password' | chpasswd

ENV GOPATH /go

ADD config.yml.tpl /var/opt/kube/
ADD entrypoint.sh /var/opt/kube/
RUN chown -R kube:kube /var/opt/kube

USER kube


RUN set -ex && \
    mkdir -p $HOME/.kube && \
    go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator

WORKDIR /var/opt/kube

ENTRYPOINT ["/var/opt/kube/entrypoint.sh"]
