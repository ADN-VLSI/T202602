export SHELL=/bin/bash

TOP := hello

SEED := 0

COV := 0

ROOT_DIR := $(CURDIR)

FILELIST  := $(shell find $(ROOT_DIR)/interface -type f -name "*.sv")
FILELIST  += $(shell find $(ROOT_DIR)/design -type f -name "*.sv")
FILELIST  += $(shell find $(ROOT_DIR)/testbench -type f -name "*.sv")

EWHL := | grep -iE "Error:|Warning:|" --color=auto

build:
	@echo "Creating build directory..."
	@mkdir build
	@echo "*" > build/.gitignore

.PHONY: clean
clean:
	@echo "Cleaning build directory..."
	@rm -rf build

.PHONY: all
all:
	@make -s clean
	@make -s build
	@git submodule update --init --depth 1
	@cd build && xvlog -sv $(FILELIST) $(EWHL)
	@cd build && xelab $(TOP) -s $(TOP)_sim --O0 -debug all $(EWHL)
	@echo "--testplusarg seed=$(SEED)" > build/xsim_args
	@cd build && xsim $(TOP)_sim -runall -sv_seed $(SEED) -f xsim_args $(EWHL)
ifneq ($(COV),0)
	@cd build && xcrg -report_format html
endif
