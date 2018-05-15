all:
	go build && ./.packer build docker.template
