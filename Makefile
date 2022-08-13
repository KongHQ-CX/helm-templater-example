KUBECONFIG_FILE=~/.kube/config

.PHONY: install-kongs
install-kongs: build-tools-image
	@docker run -it --rm -v $(PWD):/data -v $(KUBECONFIG_FILE):/mnt/kube/config kong-tools:latest installKongs

.PHONY: build-tools-image
build-tools-image:
	@docker build -t kong-tools:latest .
