ifeq ($(shell which erl),)
$(error Can't find Erlang executable 'erl')
exit 1
endif

LIB_DIR = _build/default/lib
ROOT_DIR = $(shell pwd)
PRIV_DIR = $(ROOT_DIR)/priv
LOG_DIR = $(ROOT_DIR)/log
EBIN_DIR = $(ROOT_DIR)/ebin
PA_DIRS = $(shell find $(ROOT_DIR)/_build -maxdepth 3 -mindepth 3 -exec printf "%s/ebin --pa " {} \;)

### >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
### Docker make targets
### >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

YAWS_DIR = $(LIB_DIR)/yaws
APP_DIR = $(LIB_DIR)/lfeyawsdemo
YAWS_ID = dockerlfeyawsdemo

compile:
	@mkdir -p $(LOG_DIR) $(EBIN_DIR)
	@rebar3 compile

$(YAWS_DIR)/configure:
	@mkdir -p $(LOG_DIR)
	@cd $(YAWS_DIR) && \
	autoreconf -fi && \
	./configure

$(PRIV_DIR):
	@cp -r $(APP_DIR)/priv .

lfe.config:
	@cp $(APP_DIR)/lfe.config .

yaws: $(YAWS_DIR)/configure $(PRIV_DIR) lfe.config
	@cd $(YAWS_DIR) && make > /dev/null

run: compile
	@$(YAWS_DIR)/bin/yaws -i \
	--pa $(PA_DIRS) ebin \
	--conf $(APP_DIR)/priv/etc/yaws.conf \
	--id $(YAWS_ID)

daemon: compile
	@$(YAWS_DIR)/bin/yaws \
	--pa $(PA_DIRS) ebin \
	-D --heart \
	--conf $(APP_DIR)/priv/etc/yaws.conf \
	--id $(YAWS_ID)

stop:
	@$(YAWS_DIR)/bin/yaws \
	--pa $(PA_DIRS) ebin \
	--stop --id $(YAWS_ID)

### >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
### Docker make targets
### >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

IMAGE_TAG = lfex/lfe-yaws-sample-app
IMAGE_VERSION = latest

docker-build: compile
	docker build -t $(IMAGE_TAG):$(IMAGE_VERSION) .

docker-shell:
	docker run -i -t $(IMAGE_TAG):$(IMAGE_VERSION) bash

docker-run:
	docker run -p 5099:5099 -t $(IMAGE_TAG):$(IMAGE_VERSION)

docker-push:
	docker push $(IMAGE_TAG):$(IMAGE_VERSION)
