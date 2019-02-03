#!/bin/bash

cat /var/opt/kube/config.yml.tpl | envsubst > ~/.kube/config

exec "$@"
