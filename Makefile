.DEFAULT_GOAL:=test
.PHONY: node test deploy

REPO:=esselius/straps
TAG:=$(shell git rev-parse --short HEAD)
IMAGE:="$(REPO):$(TAG)"

# Build, run tests and clean up
test:
	@$(MAKE)  build    IMAGE=$(IMAGE)
	@-$(MAKE) safe_run IMAGE=$(IMAGE) COMMAND="test"

# Build, run live tests and clean up
live-test:
	@$(MAKE)  build    IMAGE=$(IMAGE) REDIR=">/dev/null"
	@-$(MAKE) run 		 IMAGE=$(IMAGE) OPTS="-e ENVIRONMENT=production" COMMAND="live-test"

# Pull base image, build, run tests, push to registry and clean up
deploy:
	@$(MAKE) build    IMAGE=$(IMAGE) OPTS="--pull --no-cache"
	@$(MAKE) safe_run IMAGE=$(IMAGE) COMMAND="test"
	@$(MAKE) publish  IMAGE=$(IMAGE)

clean:
	@$(MAKE) clean_artifacts REPO=$(REPO)

# These targets are not intended for direct use
run:
	@docker run $(OPTS) -i --rm -e AWS_ACCESS_KEY_ID=$${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=$${AWS_SECRET_ACCESS_KEY} $(IMAGE) $(COMMAND)

safe_run:
	@docker run $(OPTS) -i --net=none --rm -e AWS_ACCESS_KEY_ID="" -e AWS_SECRET_ACCESS_KEY="" $(IMAGE) $(COMMAND)

build:
	@docker build $(OPTS) -t $(IMAGE) . $(REDIR)

publish:
	docker push $(IMAGE)

clean_artifacts:
	@docker rmi -f $$(docker images -q $(REPO)) $(REDIR)
