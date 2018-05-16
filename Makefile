PACKER := ~/bin/packer
GOBIN  ?= $(shell go env GOPATH)/bin

.PHONY: all plugins test

all: plugins

plugins: $(GOBIN)/packer-provisioner-sshproxy

test:
	$(PACKER) build -only docker docker.template

clean:
	-rm $(GOBIN)/packer-provisioner-sshproxy

$(GOBIN)/%: plugin/%.go
	GOBIN=$(GOBIN) go install $<
