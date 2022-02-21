FROM node:current-alpine3.12

ARG SPARK_VERSION

RUN apk update
RUN apk add tini curl jq bash

RUN npm install -g spark-wallet@${SPARK_VERSION}

ADD ./configurator/target/aarch64-unknown-linux-musl/release/configurator /usr/local/bin/configurator
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
COPY ./health-check.sh /usr/local/bin/health-check.sh
RUN chmod a+x /usr/local/bin/health-check.sh

WORKDIR /root/.spark-wallet

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
