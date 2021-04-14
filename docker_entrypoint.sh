#!/bin/sh

export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')

echo /root/.spark-wallet/start9/public > /root/.spark-wallet/.backupignore
echo /root/.spark-wallet/start9/shared >> /root/.spark-wallet/.backupignore

configurator
exec tini spark-wallet -c /root/.spark-wallet/config
