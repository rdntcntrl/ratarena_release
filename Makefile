.PHONY: release qvm clean clean_assets clean_gamecode clean_output distclean

GAMECODE_DIR := ratoa_gamecode
GAMECODE_QVM_DIR := $(GAMECODE_DIR)/build/release-linux-x86_64/baseq3/vm
ASSETS_DIR := ratoa_assets

GAMECODE_OPTS := WITH_MULTITOURNAMENT=1

OUTPUT_DIR := build
PK3_DIR := $(OUTPUT_DIR)/pk3

RATMOD_PK3 = z-ratmod-$(shell cd $(GAMECODE_DIR) && \
		    git describe --tags --abbrev --dirty).pk3

release: qvm $(OUTPUT_DIR) 
	rm -rf $(PK3_DIR)
	mkdir $(PK3_DIR)
	cp -r $(ASSETS_DIR)/assets/* $(PK3_DIR)/
	cp $(GAMECODE_DIR)/README.md $(PK3_DIR)/
	mkdir $(PK3_DIR)/vm
	cp $(GAMECODE_QVM_DIR)/*.qvm $(PK3_DIR)/vm/
	cd $(PK3_DIR) && zip -r ../$(RATMOD_PK3) -- .

qvm:
	$(MAKE) -C $(GAMECODE_DIR) $(GAMECODE_OPTS) \
		BUILD_GAME_SO=0 BUILD_GAME_QVM=1

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

clean_assets:
	$(MAKE) -C $(ASSETS_DIR) clean

clean_gamecode:
	$(MAKE) -C $(GAMECODE_DIR) clean

clean_output:
	rm -rf $(OUTPUT_DIR)

clean: clean_assets clean_gamecode clean_output

distclean: clean_assets clean_output
	$(MAKE) -C $(GAMECODE_DIR) distclean
