BUTANE = podman run -i --rm --volume .:/butane quay.io/coreos/butane:release --files-dir /butane --pretty --strict
GZIP = gzip -c9
BASE64 = base64 -w0
YQ_MERGE = yq eval-all '. as $$item ireduce ({}; . *+ $$item )'

BASE_DIR = ./

BASE_CONFIG = _base.bu

_BASE_CONFIG = $(addprefix $(BASE_DIR), $(BASE_CONFIG))

.PHONY: all clean controller worker
.SUFFIXES: .b64 .ign .bu

all:

clean:
	rm -f *.ign *.b64

controller: $(_CONTROLLER_FILES)

worker: $(_WORKER_FILES)

.ign.b64:
	$(GZIP) $< | $(BASE64) > $@

.bu.ign:
	$(YQ_MERGE) $(_BASE_CONFIG) $< | $(BUTANE) > $@
