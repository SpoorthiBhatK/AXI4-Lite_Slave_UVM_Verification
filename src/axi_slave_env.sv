`include "defines.sv"

class axi_slave_env extends uvm_env;

`uvm_component_utils(axi_slave_env)

axi_slave_inp_agent inp_agt;
axi_slave_op_agent op_agt;
axi_slave_scoreboard scb;
axi_slave_subscriber sub;
axi_slave_config m_cfg;
  
function new(string name = "axi_slave_env", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(axi_slave_config)::get(this,"","axi_slave_config",m_cfg))
		`uvm_fatal(get_type_name(), "Failed to get axi_slave_config")
      

	inp_agt = axi_slave_inp_agent::type_id::create("inp_agt", this);
	op_agt  = axi_slave_op_agent::type_id::create("op_agt", this);
	scb     = axi_slave_scoreboard::type_id::create("scb", this);
	sub     = axi_slave_subscriber::type_id::create("sub", this);

endfunction


function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	inp_agt.inp_mon.inp_m_port.connect(
		scb.ip_mon_fifo.analysis_export);

	inp_agt.inp_mon.inp_m_port.connect(
		sub.analysis_export);

	op_agt.op_mon.op_m_port.connect(
		scb.op_mon_fifo.analysis_export);

endfunction

endclass
