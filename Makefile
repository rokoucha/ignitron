.PHONY: clean
DOCKER = /usr/bin/env docker
ENCODER = base64
ENCODING_OPTION = -w0
FCC = ignition.fcc
FCCT_OPTIONS = --pretty --strict
IGNITION = ignitron.ign
IGNITION_B64 = $(IGNITION).b64
FCCT_IMAGE = quay.io/coreos/fcct:release

$(IGNITION_B64): $(IGNITION)
	$(ENCODER) $(ENCODING_OPTION) $(IGNITION) > $(IGNITION_B64)

$(IGNITION): $(FCC)
	$(DOCKER) run --rm -i $(FCCT_IMAGE) $(FCCT_OPTIONS) < $(FCC) > $(IGNITION)

clean:
	rm -f $(IGNITION) $(IGNITION_B64)
