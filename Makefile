.PHONY: install test build serve clean pack deploy ship

# Will use git hash for tagging. It's unique, shows relation between 
# commit log and artifacts, and easy to generate
TAG?=$(shell git rev-list HEAD --max-count=1 --abbrev-commit)

export TAG

install:
	go get .

# build target to run go test
test:
	go test ./...

# build target to build the binary. This will statically linking 
# everything required to run it
build: install
	go build -ldflags "-X main.version=$(TAG)" -o godeploy .

serve: build
	./godeploy

clean:
	rm ./godeploy

# Need a deployable unit to distribute 
# Use Dockerfile to pack application into docker image.
pack: build
	GOOS=linux make build
	docker build -t deranton/godeploy:$(TAG) .

upload:
	docker push deranton/godeploy:$(TAG)

deploy:
	envsubst < k8s/deployment.yml | kubectl apply -f -

ship: test pack upload deploy clean
