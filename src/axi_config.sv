`include "defines.sv"

class axi_config extends uvm_object;

`uvm_object_utils(axi_config)

virtual axi_interface vif;

uvm_active_passive_enum axi_inp_agent_is_active;
uvm_active_passive_enum axi_op_agent_is_active;

function new(string name = "axi_config");
	super.new(name);
endfunction

endclass
