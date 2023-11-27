#clean_docker:
#	docker image rm $(docker image ls | awk '{print $3}') --force
build_repo:
	docker build --no-cache --force-rm --pull -t nginx:repo ./nginx
start_repo:
	docker run -d -p 83:44 -p 84:8 nginx:repo
run_docker: build_repo start_repo
run_nexus: 
	mkdir -p /opt/nexus/nexus-data
	chmod -R 777 /opt/nexus/nexus-data
	docker-compose -f ./nexus/docker-compose.yaml up -d
configure_nexus:
	chmod +x ./nexus/configure-nexus.sh
	./nexus/configure-nexus.sh
get_repo:
	docker build --no-cache --force-rm --pull -t nginx:repo ./nexus
run_docker_nexus: run_nexus configure_nexus get_repo