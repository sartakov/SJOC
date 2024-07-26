OPENSCAD = openscad
SCAD_FILE = default.scad
#SCAD_FILE = vostok.scad
STL_DIR = stl_outputs

# Parameters and corresponding output files
PARAMS = gen_base gen_body gen_cone
STL_FILES = $(foreach param, $(PARAMS), $(STL_DIR)/model_$(param).stl)

# Default target
all: $(STL_FILES) $(STL_DIR)/default.ork

# Rule to convert SCAD to STL with different parameters
$(STL_DIR)/model_%.stl: $(SCAD_FILE)
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o $@ -D $*=1 $<

$(STL_DIR)/default.ork: $(SCAD_FILE)
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) --export-format=stl -o /dev/null -D gen_ork=1 default.scad 2>&1 | grep ECHO | sed 's/^ECHO: "//; s/"$$//' > stl_outputs/default.ork


# Clean up generated files
clean:
	rm -rf $(STL_DIR)

# Phony targets
.PHONY: all clean
