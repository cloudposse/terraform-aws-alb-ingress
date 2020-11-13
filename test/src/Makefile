PACKAGE  = terraform-aws-alb-ingress
GOEXE   ?= /usr/bin/go
GOPATH   = $(CURDIR)/.gopath
GOBIN    = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PATH 	:= $(PATH):$(GOBIN)

export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true
export TERRAFORM_VERSION ?= $(shell curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version' | cut -d. -f1-2)
export GOPATH

.PHONY: all
## Default target
all: test

ifneq (,$(wildcard /sbin/apk))
## Install go, if not installed
$(GOEXE):
	apk add --update go
endif

ifeq ($(shell uname -s),Linux)
## Install all `dep`, if not installed
$(GOBIN)/dep:
	@mkdir -p $(GOBIN)
	@curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
endif

## Prepare the GOPATH
$(BASE): $(GOEXE)
	@mkdir -p $(dir $@)
	@ln -sf $(CURDIR) $@

## Download vendor dependencies to vendor/
$(BASE)/vendor: $(BASE) $(GOBIN)/dep
	cd $(BASE) && dep ensure

.PHONY : init
## Initialize tests
init: $(BASE)/vendor

.PHONY : test
## Run tests
test: init
	cd $(BASE) && go test -v -timeout 30m -run TestExamplesComplete

## Run tests in docker container
docker/test:
	docker run --name terratest --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e GITHUB_TOKEN \
		-e PATH="/usr/local/terraform/$(TERRAFORM_VERSION)/bin:/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
		-v $(CURDIR)/../../:/module/ cloudposse/test-harness:pr-18-merge -C /module/test/src test

.PHONY : clean
## Clean up files
clean:
	rm -rf .gopath/ vendor/ $(TF_DATA_DIR)
