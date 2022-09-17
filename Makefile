.PHONY: help dist publish promote
SHELL=/bin/bash
ECR_REGISTRY=openhistorymap
DATETIME:=$(shell date -u +%Y%m%dT%H%M%SZ)

help: ## Print this message
	@awk 'BEGIN { FS = ":.*##"; print "Usage:  make <target>\n\nTargets:" } \
		/^[-_[:alpha:]]+:.?*##/ { printf "  %-15s%s\n", $$1, $$2 }' $(MAKEFILE_LIST)

dist: ## Build docker image
	docker build -t $(ECR_REGISTRY)/cantaloupe:latest \
		-t $(ECR_REGISTRY)/cantaloupe:`git describe --always`

publish: dist ## Build, tag and push
	docker push $(ECR_REGISTRY)/cantaloupe:latest
	docker push $(ECR_REGISTRY)/cantaloupe:`git describe --always`

promote: ## Promote the current staging build to production
	docker pull $(ECR_REGISTRY)/cantaloupe:latest
	docker tag $(ECR_REGISTRY)/cantaloupe:latest
	docker tag $(ECR_REGISTRY)/cantaloupe:latest
	docker push $(ECR_REGISTRY)/cantaloupe:latest
	docker push $(ECR_REGISTRY)/cantaloupe:$(DATETIME)
