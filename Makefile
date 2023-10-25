#@author Fred Brooker <git@gscloud.cz>
include .env

all: info

info:
	@echo "build|push"

build:
	docker build --pull -t ${TAG} .

push:
	docker push ${TAG}
