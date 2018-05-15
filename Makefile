PACKER := ~/bin/packer
all:
	go build && $(PACKER) build -only docker docker.template
