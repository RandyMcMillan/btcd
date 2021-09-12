# PROJECT_NAME defaults to name of the current directory.
ifeq ($(project),)
PROJECT_NAME							:= $(notdir $(PWD))
else
PROJECT_NAME							:= $(project)
endif
export PROJECT_NAME

ifeq ($(user),)
HOST_USER								:= root
HOST_UID								:= $(strip $(if $(uid),$(uid),0))
else
HOST_USER								:=  $(strip $(if $(USER),$(USER),nodummy))
HOST_UID								:=  $(strip $(if $(shell id -u),$(shell id -u),4000))
endif
export HOST_USER
export HOST_UID

BTCD_IMAGE:=$(shell echo $(docker images | awk '/btcd/'|awk ' {print $3}' | awk 'NR==1'))
export BTCD_IMAGE
#.PHONY:-
#-:
#	bash -c "docker build --tag btcd --no-cache . && docker images"
#	bash -c "docker run -it $(BTCD_IMAGE) sh"
#

#######################
.PHONY: build-shell
build-shell:
	$(DOCKER_COMPOSE) $(VERBOSE) build $(NOCACHE) shell
#######################
.PHONY: btcd
btcd:
ifeq ($(CMD_ARGUMENTS),)
	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
else
	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
endif

.PHONY: run
run: docs init
	@echo 'run'
	$(DOCKER_COMPOSE) $(VERBOSE) $(NOCACHE) up --remove-orphans &
	@echo ''

