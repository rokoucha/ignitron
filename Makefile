BUTANE = butane --files-dir $(shell pwd) --strict

TARGET = .ign

TARGET_FILES = $(addsuffix $(TARGET),$(basename $(wildcard *.bu)))

.PHONY: all clean format
.SUFFIXES: .ign .bu

all: $(TARGET_FILES)

clean:
	rm -f *.ign

format:
	$(foreach target,$(wildcard *.bu),yq -i 'sort_keys(..) | (... | select(type == "!!seq")) |= sort | (... | select(type == "!!seq")) |= sort_by(.path) | (... | select(type == "!!seq")) |= sort_by(.name)' $(target);)

.bu.ign:
	cat $< | envsubst | $(BUTANE) > $@
