`include "defines.sv"

class axi_inp_agent extends uvm_agent;

`uvm_component_utils(axi_inp_agent)

axi_driver inp_drv;
axi_inp_monitor inp_mon;
axi_sequencer wr_sqr;
axi_sequencer rd_sqr;
axi_config m_cfg;
function new(string name = "axi_inp_agent", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(axi_config)::get(this,"","axi_config",m_cfg))
		`uvm_fatal(get_type_name(), "Input_agent Getting Failed")
		inp_mon = axi_inp_monitor::type_id::create("inp_mon", this);
		if(m_cfg.axi_inp_agent_is_active == UVM_ACTIVE)begin
      			wr_sqr = axi_sequencer::type_id::create("wr_sqr", this);
      			rd_sqr = axi_sequencer::type_id::create("rd_sqr", this);
	  		inp_drv = axi_driver::type_id::create("inp_drv", this);
	end
endfunction
function void connect_phase(uvm_phase phase);
	if(m_cfg.axi_inp_agent_is_active == UVM_ACTIVE)begin
		inp_drv.seq_item_port.connect(wr_sqr.seq_item_export);
		inp_drv.rd_prt.connect(rd_sqr.seq_item_export);
	end
endfunction
endclass
