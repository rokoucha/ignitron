BUTANE = butane --files-dir $(shell pwd) --strict
GZIP = gzip -c9
BASE64 = base64 -w0

TARGET = $(addsuffix .ign,$(basename $(wildcard *.bu)))

.PHONY: all clean controller worker format
.SUFFIXES: .b64 .ign .bu

all: $(TARGET)

clean:
	rm -f *.ign *.b64

.ign.b64:
	$(GZIP) $< | $(BASE64) > $@

.bu.ign:
	$(BUTANE) > $@

format:
	$(foreach target,$(wildcard *.bu),yq -i 'sort_keys(..) | (... | select(type == "!!seq")) |= sort | (... | select(type == "!!seq")) |= sort_by(.path) | (... | select(type == "!!seq")) |= sort_by(.name)' $(target);)
