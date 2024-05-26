BUTANE = butane --files-dir ./butane --pretty --strict
GZIP = gzip -c9
BASE64 = base64 -w0
YQ_MERGE = yq eval-all '. as $$item ireduce ({}; . *+ $$item )'

BASE_DIR = ./

BASE_CONFIG = _base.bu

TARGET = $(addsuffix .b64,$(basename $(filter-out $(BASE_CONFIG),$(wildcard *.bu))))

_BASE_CONFIG = $(addprefix $(BASE_DIR), $(BASE_CONFIG))

.PHONY: all clean controller worker format
.SUFFIXES: .b64 .ign .bu

all: $(TARGET)

clean:
	rm -f *.ign *.b64 $(TARGET)

controller: $(_CONTROLLER_FILES)

worker: $(_WORKER_FILES)

.ign.b64:
	$(GZIP) $< | $(BASE64) > $@

.bu.ign:
	$(YQ_MERGE) $(_BASE_CONFIG) $< | $(BUTANE) > $@

format:
	$(foreach target,$(wildcard *.bu),yq -i 'sort_keys(..) | (... | select(type == "!!seq")) |= sort | (... | select(type == "!!seq")) |= sort_by(.path) | (... | select(type == "!!seq")) |= sort_by(.name)' $(target);)
