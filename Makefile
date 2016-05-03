EXTRACTOR = bin/docset_extractor.rb
VALIDATE = swagger validate
API_NAMES = cmsapiv2 auth
PUBLIC_DOCSETS := $(API_NAMES:%=%_public.json)
PRIVATE_DOCSETS := $(API_NAMES:%=%_internal.json)
DOCSETS := $(PUBLIC_DOCSETS) $(PRIVATE_DOCSETS)

all: $(DOCSETS)

%_public.json : %.json
	$(EXTRACTOR) $< $@ public

%_internal.json : %.json
	$(EXTRACTOR) $< $@ internal

validate: all
	$(foreach docset,$(DOCSETS),$(VALIDATE) $(docset);)

clean:
	rm -f $(DOCSETS)
