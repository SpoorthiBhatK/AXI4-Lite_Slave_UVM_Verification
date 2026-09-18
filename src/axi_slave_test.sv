`include "defines.sv"

class axi_slave_test extends uvm_test;

`uvm_component_utils(axi_slave_test)

axi_slave_env env;
axi_slave_config m_cfg;

function new(string name = "axi_slave_test", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	m_cfg = axi_slave_config::type_id::create("m_cfg");

	if(!uvm_config_db #(virtual axi_slave_interface)::get(this,"","axi_slave_interface",m_cfg.vif))
		`uvm_fatal(get_type_name(), "Can't get the interface")

	m_cfg.axi_slave_inp_agent_is_active = UVM_ACTIVE;
	m_cfg.axi_slave_op_agent_is_active  = UVM_PASSIVE;

  uvm_config_db #(axi_slave_config)::set(this,"*","axi_slave_config",m_cfg);

	env = axi_slave_env::type_id::create("env", this);

endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction

endclass


class test1 extends axi_slave_test;

`uvm_component_utils(test1)

axi_slave_sequence s1;

function new(string name="test1", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);

	phase.raise_objection(this);

	s1 = axi_slave_sequence::type_id::create("s1");
	s1.start(env.inp_agt.sqr);

	phase.drop_objection(this);

endtask

endclass
