SRCS := templates/config.yaml templates/default.mustache build/schemes
DEST := colors

.PHONY: all help deps update clean

all: $(DEST)

help:
	@echo "Targets:"
	@echo "help    show this help message"
	@echo "deps    install pybase16-builder"
	@echo "update  clone/pull base16 schemes"
	@echo "all     build schemes for kitty"
	@echo "clean   delete scheme repos"

deps:
	pip3 install pybase16-builder

update:
	./update.sh

$(DEST): $(SRCS)
	./build.sh

clean:
	rm -rf build
