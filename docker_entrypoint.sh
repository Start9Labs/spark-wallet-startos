#!/bin/sh

export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')

echo start9/public > .backupignore
echo start9/shared >> .backupignore

configurator
exec tini spark-wallet -c /root/.spark-wallet/config
