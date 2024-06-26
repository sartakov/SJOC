OPENSCAD = openscad
SCAD_FILE = default.scad
STL_DIR = stl_outputs

# Parameters and corresponding output files
PARAMS = gen_base gen_body gen_cone gen_rod_spacer
STL_FILES = $(foreach param, $(PARAMS), $(STL_DIR)/model_$(param).stl)

# Default target
all: $(STL_FILES)

# Rule to convert SCAD to STL with different parameters
$(STL_DIR)/model_%.stl: $(SCAD_FILE)
	@mkdir -p $(STL_DIR)
	$(OPENSCAD) -o $@ -D $*=1 $<

# Clean up generated files
clean:
	rm -rf $(STL_DIR)

# Phony targets
.PHONY: all clean
