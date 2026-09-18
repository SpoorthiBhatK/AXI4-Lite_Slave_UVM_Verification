# ====================================================================
# Advanced Makefile for UVM Compilation and Regression using VCS
# ====================================================================
 
# --- Configuration & Paths ---
VCS       = vcs
OUT_DIR   = work
SIM       = $(OUT_DIR)/simv
TB_TOP    = axi_top.sv
LOG_DIR   = $(OUT_DIR)/logs
COV_DIR   = $(OUT_DIR)/regression.vdb
 
# --- Default Run Arguments ---
TESTNAME  ?= write_read
VERBOSITY ?= UVM_HIGH
SEED      ?= random
ITER      ?= 1
WAVES     ?= 0
GUI       ?= 0
 
# --- Tool Options ---
# Base VCS options
VCS_OPTS  = -sverilog -full64 -ntb_opts uvm -timescale=1ns/1ns -Mdir=$(OUT_DIR)/csrc -o $(SIM)
 
# Coverage options
COV_OPTS  = -cm line+cond+fsm+tgl+branch+assert
 
# Conditional Waveform Dumping
ifeq ($(WAVES), 1)
	VCS_OPTS += -debug_access+all +define+DUMP_WAVES
endif
 
# Conditional GUI Mode
SIM_OPTS  =
ifeq ($(GUI), 1)
	SIM_OPTS += -gui
endif
 
# List of tests to run in regression (space-separated)
 
TEST_LIST = test_write axi_write_both_test test_read test_write_ro test_read_wo test_write_unaligned write_addr_ob_test test_read_unaligned test_write_decerr test_read_decerr test_write_coverage test_awaddr_coverage test_araddr_coverage axi_write_da_test axi_write_test_addr_after_data 

# --- Targets ---
.PHONY: help setup compile run regression report clean summary
 
help:
	@echo "======================================================================"
	@echo "Usage:"
	@echo "  make compile                  - Compiles the SV/UVM testbench"
	@echo "  make run TESTNAME=my_test     - Runs a single test (Default SEED=random)"
	@echo "  make run SEED=1234 WAVES=1    - Runs with specific seed and dumps waves"
	@echo "  make run GUI=1                - Runs the simulation in interactive GUI mode"
	@echo "  make regression ITER=3        - Runs all tests in TEST_LIST 3 times with random seeds"
	@echo "  make report                   - Generates HTML coverage report"
	@echo "  make summary                  - Parses regression logs and prints PASS/FAIL"
	@echo "  make clean                    - Removes all simulation artifacts"
	@echo "======================================================================"
 
# 1. Directory Setup
setup:
	@mkdir -p $(OUT_DIR)
	@mkdir -p $(LOG_DIR)
 
# 2. Compilation
compile: setup
	@echo "========================================"
	@echo "Compiling Design and Testbench..."
	@echo "========================================"
	$(VCS) $(VCS_OPTS) $(COV_OPTS) -cm_dir $(COV_DIR) $(TB_TOP) -l $(OUT_DIR)/compile.log
 
# 3. Run a single test
run: compile
	@echo "========================================"
	@echo "Running UVM Test: $(TESTNAME)"
	@echo "========================================"
	@# Handle random seed generation if SEED=random
	$(eval RUN_SEED := $(if $(filter random,$(SEED)),$$RANDOM,$(SEED)))
	$(SIM) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) +ntb_random_seed=$(RUN_SEED) \
		$(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $(TESTNAME)_$(RUN_SEED) \
		$(SIM_OPTS) -l $(LOG_DIR)/$(TESTNAME)_$(RUN_SEED).log
	@echo "Log saved to: $(LOG_DIR)/$(TESTNAME)_$(RUN_SEED).log"
# 4. Run Regression (Iterates through TEST_LIST multiple times with random seeds)
regression: compile
	@echo "========================================"
	@echo "Starting UVM Regression"
	@echo "Tests: $(TEST_LIST)"
	@echo "Iterations per test: $(ITER)"
	@echo "========================================"
	@rm -f $(OUT_DIR)/regr_status.txt
	@for test in $(TEST_LIST); do \
		for i in $$(seq 1 $(ITER)); do \
			CURRENT_SEED=$$RANDOM; \
			echo "Running $$test (Iter: $$i/$(ITER), Seed: $$CURRENT_SEED)..."; \
			$(SIM) +UVM_TESTNAME=$$test +UVM_VERBOSITY=$(VERBOSITY) +ntb_random_seed=$$CURRENT_SEED \
				$(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $${test}_$${CURRENT_SEED} \
				-l $(LOG_DIR)/$${test}_$${CURRENT_SEED}.log +UVM_NO_RELNOTES; \
			if grep -qE "UVM_ERROR[[:space:]]*:[[:space:]]*0" $(LOG_DIR)/$${test}_$${CURRENT_SEED}.log && \
			   grep -qE "UVM_FATAL[[:space:]]*:[[:space:]]*0" $(LOG_DIR)/$${test}_$${CURRENT_SEED}.log; then \
				echo "$$test $$CURRENT_SEED PASS" >> $(OUT_DIR)/regr_status.txt; \
			else \
				echo "$$test $$CURRENT_SEED FAIL" >> $(OUT_DIR)/regr_status.txt; \
			fi; \
		done \
	done
	@$(MAKE) summary
	@$(MAKE) report
# 5. Regression Summary Checker
summary:
	@echo ""
	@echo "========================================"
	@echo "          Regression Summary            "
	@echo "========================================"
	@if [ -f $(OUT_DIR)/regr_status.txt ]; then \
		echo "TESTNAME \t\t SEED \t\t STATUS"; \
		echo "----------------------------------------"; \
		column -t $(OUT_DIR)/regr_status.txt; \
		echo "----------------------------------------"; \
		TOTAL=$$(wc -l < $(OUT_DIR)/regr_status.txt); \
		PASSED=$$(grep -c "PASS" $(OUT_DIR)/regr_status.txt || true); \
		FAILED=$$(grep -c "FAIL" $(OUT_DIR)/regr_status.txt || true); \
		echo "Total: $$TOTAL | Passed: $$PASSED | Failed: $$FAILED"; \
	else \
		echo "No regression data found."; \
	fi
	@echo "========================================"
 
# 6. Generate Coverage Report
report:
	@echo "========================================"
	@echo "Generating Cumulative Coverage Report..."
	@echo "========================================"
	urg -dir $(COV_DIR) -report $(OUT_DIR)/urgReport
	@echo "Report generated! Open $(OUT_DIR)/urgReport/dashboard.html in a browser."
 
# 7. Clean all generated files
clean:
	@echo "Cleaning simulation workspace..."
	rm -rf $(OUT_DIR) *.log *.vpd *.fsdb *.vdb urgReport DVEfiles vc_hdrs.h ucli.key .vlogansetup.args
	@echo "Clean complete."
