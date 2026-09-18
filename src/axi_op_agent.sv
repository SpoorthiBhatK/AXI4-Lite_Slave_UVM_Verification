`include "defines.sv"

class axi_op_agent extends uvm_agent;

`uvm_component_utils(axi_op_agent)

axi_op_monitor op_mon;
axi_config o_m_cfg;
virtual axi_interface inf;
  
function new(string name = "axi_op_agent", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(axi_config)::get(this,"","axi_config",o_m_cfg))
    `uvm_fatal(get_type_name(), "Failed to get axi_config")
	if(o_m_cfg.axi_op_agent_is_active == UVM_PASSIVE)begin
      op_mon = axi_op_monitor::type_id::create("op_mon", this);
	end
endfunction

endclass
