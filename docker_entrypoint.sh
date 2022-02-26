#!/bin/sh

configurator

if ! test -d /mnt/c-lightning
then
    exit 0
fi
while ! test -S /mnt/c-lightning/shared/lightning-rpc
do
    echo "Waiting for c-lightning RPC socket..."
    sleep 1
done
while ! socat -u open:/dev/null unix-connect:/mnt/c-lightning/shared/lightning-rpc
do
    echo "Waiting for c-lightning RPC socket to accept connections..."
    sleep 1
done
exec tini spark-wallet -c /root/.spark-wallet/config