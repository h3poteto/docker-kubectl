#!/bin/bash

cat /var/opt/config.yml/tpl | envsubst > ~/.kube/config

exec "$@"
