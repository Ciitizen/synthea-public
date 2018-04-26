SERVICE                 := synthea
# Check for required dev tools installed
preflight:
	which docker

clean:
	rm -fr ./output/*

clean-docker: clean
	docker rmi -f $(docker images -a -q)
	docker rm -f $(docker ps -a -q)

# Build docker images and tag them consistently
build:
	docker build -t $(SERVICE) .

run:
	docker run -v ${PWD}/output:/home/gradle/output $(SERVICE)

.PHONY: build run preflight
