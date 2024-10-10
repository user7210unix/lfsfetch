# Makefile for lfsfetch

# Define variables
SHELL_SCRIPT=lfsfetch.sh
INSTALL_DIR=/usr/local/bin

# Targets
.PHONY: all install clean

all: install

install:
	@echo "Installing $(SHELL_SCRIPT) to $(INSTALL_DIR)"
	@install -Dm755 $(SHELL_SCRIPT) $(INSTALL_DIR)/lfsfetch

clean:
	@echo "Nothing to clean."

