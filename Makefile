version=$(shell git describe --tags)
repository=nginx
user=hatlonely

.PHONY: deploy remove build push

deploy:
	mkdir -p /var/docker/${repository}/log
	mkdir -p /var/docker/${repository}/run
	mkdir -p /var/docker/${repository}/data
	mkdir -p /var/docker/${repository}/conf
	cp nginx.conf /var/docker/${repository}/conf
	cp -r conf.d /var/docker/${repository}/conf
	docker stack deploy -c stack.yml ${repository}

remove:
	docker stack rm ${repository}

build:
	docker build --tag=${user}/${repository}:${version} .
	cat stack.tpl.yml | sed 's/\$${version}/${version}/g' | sed 's/\$${repository}/${repository}/g' > stack.yml

push:
	docker push ${user}/${repository}:${version}

logs:
	docker logs $$(docker ps --filter name=$(repository) -q)