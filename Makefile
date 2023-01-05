#@author Fred Brooker <git@gscloud.cz>
include .env

all: build

build:
	docker build --pull -t ${TAG} .

push:
	docker push ${TAG}

scan:
	docker scan ${TAG}
