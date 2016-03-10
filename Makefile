EXTRACTOR = bin/docset_extractor.rb
VALIDATE = swagger validate
TARGET = neon-lab-api.json
DOCSETS = public.json internal.json

build: $(TARGET)
	$(EXTRACTOR) $(TARGET)

validate: build
	$(foreach docset,$(DOCSETS),$(VALIDATE) $(docset);)

clean:
	rm -f $(DOCSETS)
