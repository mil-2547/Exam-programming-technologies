

_image_name := jconf
_image_tag  := v1
_jenkins_id := $(firstword $(shell docker compose ps -q 2>nul))

all: build up

build:
	@echo [DOCKER] Building image $(_image_name):$(_image_tag)...
	docker build -t $(_image_name):$(_image_tag) .

up:
	@echo [DOCKER] Starting compose...
	docker compose up -d
	@echo [INFO] System is up :: running $(_image_name):$(_image_tag)

down:
	@echo [DOCKER] Stopping...
	docker compose down
	@echo [INFO] Stopped.

key:
	@if "$(_jenkins_id)"=="" ( \
		echo [ERROR] Container not running. Run 'make up' first. && exit 1 \
	)
	@echo [SECRET] Initial Admin Password:
	@docker exec $(_jenkins_id) cat /var/jenkins_home/secrets/initialAdminPassword