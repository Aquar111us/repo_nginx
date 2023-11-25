#clean_docker:
#	docker image rm $(docker image ls | awk '{print $3}') --force
build_repo:
	docker build --no-cache --force-rm --pull -t nginx:repo .
start_repo:
	docker run -d -p 83:44 -p 84:8 nginx:repo
run_docker: build_repo start_repo
