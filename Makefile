EXTRACTOR = bin/docset_extractor.rb
VALIDATE = swagger validate
API_NAMES = cmsapiv2
PUBLIC_DOCSETS := $(API_NAMES:%=%.public.json)
PRIVATE_DOCSETS := $(API_NAMES:%=%.internal.json)
DOCSETS := $(PUBLIC_DOCSETS) $(PRIVATE_DOCSETS)

all: $(DOCSETS)

%.public.json : %.json
	$(EXTRACTOR) $< $@ public

%.internal.json : %.json
	$(EXTRACTOR) $< $@ internal

validate: all
	$(foreach docset,$(DOCSETS),$(VALIDATE) $(docset);)

clean:
	rm -f $(DOCSETS)
