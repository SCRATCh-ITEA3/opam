DIR := $(notdir $(CURDIR))

build:
	@docker build . -t $(DIR) | tee .buildlog

shell: build
	@docker run --rm -it $(shell grep "Successfully built" .buildlog | cut -d ' ' -f 3)
