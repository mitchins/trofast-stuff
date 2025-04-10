# Variables
SCAD_FILE := Trofast_Flexible_Runners.scad
OUTPUT_DIR := output
VARIANTS := Center Left Right Test
PREVIEWS := front side top

# Camera settings for each preview
CAMERA_front := --camera=0,0,0,0,0,0,0
CAMERA_side := --camera=0,0,0,0,90,0,0
CAMERA_top := --camera=0,0,0,90,0,0,0

# Default target to build all variants
all: $(VARIANTS)

# Build each variant and generate previews
$(VARIANTS):
	mkdir -p $(OUTPUT_DIR)
	@echo "Building STL for variant: $@"
	@openscad -D mode='"$@"' -o $(OUTPUT_DIR)/MyModel_$@.stl $(SCAD_FILE)
	@$(foreach view,$(PREVIEWS), \
		echo "Generating preview for variant: $@, view: $(view)"; \
		echo "Using camera arguments: $(CAMERA_$(view))"; \
		openscad -D mode='"$@"' $(CAMERA_$(view)) --viewall --autocenter --render --imgsize=800,600 -o $(OUTPUT_DIR)/MyModel_$@_$(view).png $(SCAD_FILE);)

# Clean target to remove output files
clean:
	rm -rf $(OUTPUT_DIR)

.PHONY: all clean $(VARIANTS)
