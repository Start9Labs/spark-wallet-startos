#!/bin/sh

configurator
exec tini spark-wallet -c /root/.spark-wallet/config
