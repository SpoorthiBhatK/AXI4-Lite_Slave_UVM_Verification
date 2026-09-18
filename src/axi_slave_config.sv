`include "defines.sv"

class axi_slave_config extends uvm_object;

`uvm_object_utils(axi_slave_config)

virtual axi_slave_interface.DRV vif;

uvm_active_passive_enum axi_slave_inp_agent_is_active;
uvm_active_passive_enum axi_slave_op_agent_is_active;

function new(string name = "axi_slave_config");
	super.new(name);
endfunction

endclass
