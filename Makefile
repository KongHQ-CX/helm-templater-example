.PHONY: install-kongs
install-kongs: build-tools-image
	docker run -it --rm -v $(pwd):/data kong-tools:latest installKongs

.PHONY: build-tools-image
build-tools-image:
	docker build -t kong-tools:latest .
