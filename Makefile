BUTANE = podman run -i --rm --volume .:/butane quay.io/coreos/butane:release --files-dir /butane --pretty --strict
GZIP = gzip -c9
BASE64 = base64 -w0

.PHONY: clean
.SUFFIXES: .b64 .ign .bu

tomoko.b64: tomoko.bu

clean:
	rm -f tomoko.ign.b64

.ign.b64:
	$(GZIP) $< | $(BASE64) > $@

.bu.ign:
	$(BUTANE) /butane/$< > $@
