`include "defines.sv"

class axi_slave_inp_agent extends uvm_agent;

`uvm_component_utils(axi_slave_inp_agent)

axi_slave_driver inp_drv;
axi_slave_inp_monitor inp_mon;
axi_slave_sequencer sqr;
axi_slave_config m_cfg;

function new(string name = "axi_slave_inp_agent", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(axi_slave_config)::get(this,"","axi_slave_config",m_cfg))
		`uvm_fatal(get_type_name(), "Input_agent Getting Failed")

	inp_mon = axi_slave_inp_monitor::type_id::create("inp_mon", this);

	if(m_cfg.axi_slave_inp_agent_is_active == UVM_ACTIVE)
	begin
		sqr     = axi_slave_sequencer::type_id::create("sqr", this);
		inp_drv = axi_slave_driver::type_id::create("inp_drv", this);
	end

endfunction

function void connect_phase(uvm_phase phase);

	if(m_cfg.axi_slave_inp_agent_is_active == UVM_ACTIVE)
	begin
		inp_drv.seq_item_port.connect(sqr.seq_item_export);
	end

endfunction

endclass
