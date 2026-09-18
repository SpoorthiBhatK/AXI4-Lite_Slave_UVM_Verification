package axi_slave_package;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "axi_slave_config.sv"

`include "axi_slave_seq_item.sv"
`include "axi_slave_sequence.sv"
`include "axi_slave_sequencer.sv"
`include "axi_slave_driver.sv"
`include "axi_slave_inp_monitor.sv"
`include "axi_slave_op_monitor.sv"
`include "axi_slave_inp_agent.sv"
`include "axi_slave_op_agent.sv"
`include "axi_slave_scoreboard.sv"
`include "axi_slave_subscriber.sv"
`include "axi_slave_env.sv"
`include "axi_slave_test.sv"

endpackage
