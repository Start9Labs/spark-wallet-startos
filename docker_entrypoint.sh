#!/bin/sh

configurator
while ! test -S /mnt/c-lightning/shared/lightning-rpc
do
    echo "Waiting for c-lightning RPC..."
    sleep 1
done
while ! socat -u open:/dev/null unix-connect:/mnt/c-lightning/shared/lightning-rpc
do
    echo "Waiting for c-lightning RPC..."
    sleep 1
done
exec tini spark-wallet -c /root/.spark-wallet/config