ASSET_PATHS := $(shell find ./assets/*)
EMVER := $(shell yq e '.version'  manifest.yaml)
SPARK_VERSION := $(shell echo $(EMVER) | sed -E 's/^([0-9]+)\.([0-9]+)\.([0-9]+).*/\1.\2.\3/g')
CONFIGURATOR_SRC := $(shell find ./configurator/src) configurator/Cargo.toml configurator/Cargo.lock
S9PK_PATH=$(shell find . -name spark-wallet.s9pk -print)
TS_FILES := $(shell find . -name \*.ts )

.DELETE_ON_ERROR:

all: verify

clean:
	rm spark-wallet.s9pk
	rm image.tar

verify: spark-wallet.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

install: spark-wallet.s9pk 
	embassy-cli package install spark-wallet

spark-wallet.s9pk: manifest.yaml image.tar instructions.md icon.png LICENSE $(ASSET_PATHS)  scripts/embassy.js
	embassy-sdk pack

instructions.md: docs/instructions.md
	cp docs/instructions.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh health-check.sh configurator/target/aarch64-unknown-linux-musl/release/configurator
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/spark-wallet/main:${EMVER} --build-arg SPARK_VERSION=$(SPARK_VERSION) --platform=linux/arm64 -o type=docker,dest=image.tar .

configurator/target/aarch64-unknown-linux-musl/release/configurator: $(CONFIGURATOR_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js