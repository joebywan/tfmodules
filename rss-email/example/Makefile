# Directory for virtual environment and layer packaging
VENV_DIR := .venv
LAYER_DIR := python
ZIP_FILE := feedparser_layer.zip
LAMBDA_ZIP_FILE = lambda_function.zip

# Python runtime version for AWS Lambda
PYTHON_VERSION := python3.11

# Terraform commands
TERRAFORM := terraform

# Makefile targets
$(ZIP_FILE): build_layer

build_layer:
	# Create a virtual environment
	$(PYTHON_VERSION) -m venv $(VENV_DIR)

	# Activate virtual environment and install dependencies
	$(VENV_DIR)/bin/pip install -r requirements.txt --target $(LAYER_DIR)

	# Create directory for layer files
	# mkdir -p $(LAYER_DIR)

	# Copy installed packages to layer directory
	# cp -r $(VENV_DIR)/lib/$(PYTHON_VERSION)/site-packages/* $(LAYER_DIR)/

	# Package the layer into a ZIP file
	# cd $(LAYER_DIR) && zip -r ../$(ZIP_FILE) ./python
	zip -r $(ZIP_FILE) ./python

plan: $(ZIP_FILE)
	$(TERRAFORM) init
	$(TERRAFORM) fmt
	$(TERRAFORM) validate
	$(TERRAFORM) plan

apply: $(ZIP_FILE) plan
	$(TERRAFORM) apply
	@$(MAKE) clean

destroy: $(ZIP_FILE)
	$(TERRAFORM) destroy
	@$(MAKE) clean

clean:
	# Clean up the created files and directories
	rm -rf $(VENV_DIR) $(LAYER_DIR) $(ZIP_FILE) $(LAMBDA_ZIP_FILE)

.PHONY: clean plan apply
