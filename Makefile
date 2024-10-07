BUTANE = butane --files-dir $(shell pwd) --strict
GZIP = gzip -c9
BASE64 = base64 -w0
YQ_MERGE = yq eval-all '. as $$item ireduce ({}; . *+ $$item )'

BASE_CONFIG = _base.bu

TARGET = .ign

TARGET_FILES = $(addsuffix $(TARGET),$(basename $(filter-out $(BASE_CONFIG),$(wildcard *.bu))))

.PHONY: all clean controller worker format
.SUFFIXES: .b64 .ign .bu

all: $(TARGET_FILES)

clean:
	rm -f *.ign *.b64

.ign.b64:
	$(GZIP) $< | $(BASE64) > $@

.bu.ign:
	$(YQ_MERGE) $(BASE_CONFIG) $< | $(BUTANE) > $@

format:
	$(foreach target,$(wildcard *.bu),yq -i 'sort_keys(..) | (... | select(type == "!!seq")) |= sort | (... | select(type == "!!seq")) |= sort_by(.path) | (... | select(type == "!!seq")) |= sort_by(.name)' $(target);)
