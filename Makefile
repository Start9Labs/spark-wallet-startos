ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell yq e '.version'  manifest.yaml)
SPARK_VERSION := $(shell echo $(VERSION) | sed -E 's/^([0-9]+)\.([0-9]+)\.([0-9]+).*/\1.\2.\3/g')
CONFIGURATOR_SRC := $(shell find ./configurator/src) configurator/Cargo.toml configurator/Cargo.lock

.DELETE_ON_ERROR:

all: spark-wallet.s9pk

install: spark-wallet.s9pk
	appmgr install spark-wallet.s9pk

spark-wallet.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md icon.png $(ASSET_PATHS)
	sudo $(which embassy-sdk) pack
	sudo $(which embassy-sdk) verify spark-wallet.s9pk

instructions.md: docs/instructions.md
	cp docs/instructions.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh configurator/target/aarch64-unknown-linux-musl/release/configurator
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/spark-wallet --build-arg SPARK_VERSION=$(SPARK_VERSION) --platform=linux/arm64 -o type=docker,dest=image.tar .

configurator/target/aarch64-unknown-linux-musl/release/configurator: $(CONFIGURATOR_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/configurator:/home/rust/src start9/rust-musl-cross:aarch64-musl musl-strip target/aarch64-unknown-linux-musl/release/configurator

