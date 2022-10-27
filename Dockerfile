FROM node:current-alpine3.12

ARG SPARK_VERSION
# arm64 or amd64
ARG PLATFORM
# aarch64 or x86_64
ARG ARCH

RUN apk update
RUN apk add tini curl jq bash socat

RUN wget https://github.com/mikefarah/yq/releases/download/v4.28.2/yq_linux_${PLATFORM}.tar.gz -O - |\
  tar xz && mv yq_linux_${PLATFORM} /usr/bin/yq

RUN npm install -g spark-wallet@${SPARK_VERSION}

ADD ./configurator/target/${ARCH}-unknown-linux-musl/release/configurator /usr/local/bin/configurator
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
COPY ./health-check.sh /usr/local/bin/health-check.sh
RUN chmod a+x /usr/local/bin/health-check.sh

WORKDIR /root/.spark-wallet

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
