PACKER := ~/bin/packer
GOBIN  ?= $(shell go env GOPATH)/bin

.PHONY: all plugins test fulltest fmt clean

all: plugins

plugins: $(GOBIN)/packer-provisioner-sshproxy
plugins: $(GOBIN)/packer-provisioner-testinfra

$(GOBIN)/packer-provisioner-sshproxy: provisioner/sshproxy/adapter.go
$(GOBIN)/packer-provisioner-sshproxy: provisioner/sshproxy/provisioner.go
$(GOBIN)/packer-provisioner-sshproxy: provisioner/sshproxy/scp.go

$(GOBIN)/packer-provisioner-testinfra: provisioner/testinfra/provisioner.go

test: 
	go test github.com/gshively/packer-provisioner-sshproxy/provisioner/sshproxy

fulltest: plugins
	$(PACKER) build -only docker docker.template

fmt:
	gofmt -w provisioner

clean:
	-rm $(GOBIN)/packer-provisioner-sshproxy
	-rm $(GOBIN)/packer-provisioner-testinfra

$(GOBIN)/%: plugin/%.go
	GOBIN=$(GOBIN) go install $<
