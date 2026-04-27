export SHELL=/bin/bash

export T202602=$(realpath ..)
export APB_UART=$(T202602)/submodule/apb-uart

TOP := uart_tb

FL += -i $(T202602)/oop_tb

FL += $(APB_UART)/pkg/apb_uart_pkg.sv
FL += $(APB_UART)/pkg/uart_tx_pkg.sv
FL += $(APB_UART)/pkg/uart_rx_pkg.sv
FL += $(APB_UART)/inc/common_defines.svh

FL += $(APB_UART)/intf/apb_if.sv
FL += $(APB_UART)/intf/ctrl_if.sv
FL += $(APB_UART)/intf/uart_if.sv

FL += $(APB_UART)/rtl/apb_memif.sv
FL += $(APB_UART)/rtl/uart_regif.sv
FL += $(APB_UART)/rtl/bin_to_gray.sv
FL += $(APB_UART)/rtl/gray_to_bin.sv
FL += $(APB_UART)/rtl/register.sv
FL += $(APB_UART)/rtl/register_dual_flop.sv
FL += $(APB_UART)/rtl/decoder.sv
FL += $(APB_UART)/rtl/mux.sv
FL += $(APB_UART)/rtl/demux.sv
FL += $(APB_UART)/rtl/mem.sv
FL += $(APB_UART)/rtl/cdc_fifo.sv
FL += $(APB_UART)/rtl/clk_div.sv
FL += $(APB_UART)/rtl/edge_detector.sv
FL += $(APB_UART)/rtl/uart_rx_fsm.sv
FL += $(APB_UART)/rtl/uart_rx.sv
FL += $(APB_UART)/rtl/uart_tx_fsm.sv
FL += $(APB_UART)/rtl/uart_tx.sv
FL += $(APB_UART)/rtl/uart_top.sv

FL += $(T202602)/oop_tb/uart_tb.sv

BUILD := $(T202602)/build

GUI := 0

EWHL := | grep -iE "Error:|Warning:|" --color=auto

ifneq ($(GUI),0)
	SIM_ARGS += --gui
else
	SIM_ARGS += --runall
endif


$(BUILD):
	@echo "Creating build directory at $@"
	@mkdir -p $@
	@echo "*" > $@/.gitignore

.PHONY: clean
clean:
	@rm -rf $(BUILD)

.PHONY: all
all:
	@make -s compile
	@make -s simulate TEST=$(TEST)

.PHONY: compile
compile:
	@make -s clean
	@make -s $(BUILD)
	@git submodule update --init --depth 1
	@cd $(BUILD) && xvlog -sv $(FL) $(EWHL)
	@cd $(BUILD) && xelab $(TOP) -debug all -s top $(EWHL)

.PHONY: simulate
simulate:
	@echo "--testplusarg TEST=$(TEST)" > $(BUILD)/sim_args
	@echo "$(SIM_ARGS)" >> $(BUILD)/sim_args
	@cd $(BUILD) && xsim top -f $(BUILD)/sim_args $(EWHL)
