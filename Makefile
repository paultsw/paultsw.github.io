EMACS    := emacs --batch
BUILD_EL := build.el
OUT_DIR  := docs

PAGE_ORGS  := about/index.org books/index.org stuff/index.org
POST_ORGS  := $(sort $(wildcard posts/*.org))

.PHONY: all clean build-pages build-posts build-listing copy-assets

all: clean build-pages build-posts build-listing copy-assets
	@echo "Build complete: $(OUT_DIR)/"

build-pages: $(PAGE_ORGS)
	@mkdir -p $(OUT_DIR)
	@for f in $(PAGE_ORGS); do \
		echo "Exporting $$f ..."; \
		$(EMACS) --load $(BUILD_EL) --eval '(ptsw-export-file "'$$f'")'; \
	done

build-posts: $(POST_ORGS)
	@for f in $(POST_ORGS); do \
		echo "Exporting $$f ..."; \
		$(EMACS) --load $(BUILD_EL) --eval '(ptsw-export-post "'$$f'")'; \
	done

build-listing:
	@echo "Generating blog listing..."
	$(EMACS) --load $(BUILD_EL) --eval '(ptsw-generate-blog-listing)'

copy-assets:
	@echo "Copying static assets..."
	@mkdir -p $(OUT_DIR)/images $(OUT_DIR)/js $(OUT_DIR)/_resources
	cp index.html $(OUT_DIR)/
	cp 404.html $(OUT_DIR)/
	cp CNAME $(OUT_DIR)/
	cp *tufte.css $(OUT_DIR)/
	cp -r images/* $(OUT_DIR)/images/
	cp -r js/* $(OUT_DIR)/js/ 2>/dev/null || true
	cp -r _resources/* $(OUT_DIR)/_resources/ 2>/dev/null || true
	cp -r et-book $(OUT_DIR)
	cp LICENSE $(OUT_DIR)/ 2>/dev/null || true

serve:
	uv run python -m http.server -d $(OUT_DIR) 8000

clean:
	rm -rf $(OUT_DIR)
