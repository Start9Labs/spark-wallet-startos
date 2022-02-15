#!/bin/sh

configurator
while [ ! -f /mnt/c-lightning/shared/lightning-rpc ]
do
    echo "Waiting for bitcoin RPC..."
    sleep 1
done
exec tini spark-wallet -c /root/.spark-wallet/config
