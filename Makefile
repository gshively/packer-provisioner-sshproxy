PACKER := ~/bin/packer
GOBIN  ?= $(shell go env GOPATH)/bin

.PHONY: all plugins test

all: plugins

plugins: $(GOBIN)/packer-provisioner-sshproxy

test:
	$(PACKER) build -only docker docker.template


$(GOBIN)/%: plugins/%.go
	GOBIN=$(GOBIN) go install $<
