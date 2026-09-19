class axi_test extends uvm_test;
    `uvm_component_utils(axi_test)

    axi_env env;
    axi_config m_cfg;

    function new(string name="axi_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_cfg = axi_config::type_id::create("m_cfg");

        if(!uvm_config_db #(virtual axi_interface)::get(this, "", "axi_interface", m_cfg.vif))
            `uvm_fatal(get_type_name(), "Can't get the interface")

        m_cfg.axi_inp_agent_is_active = UVM_ACTIVE;
        m_cfg.axi_op_agent_is_active = UVM_PASSIVE;

        uvm_config_db #(axi_config)::set(this, "*", "axi_config", m_cfg);

        env = axi_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
endclass
/////////////////////////////////////////////////
class test_write extends axi_test;
    `uvm_component_utils(test_write)

    axi_write_sequence wr_sq;

    function new(string name="test_write", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        wr_sq = axi_write_sequence::type_id::create("wr_sq");
        wr_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////
class test_read extends axi_test;
    `uvm_component_utils(test_read)

    axi_read_sequence rd_sq;
    axi_write_sequence wr_sq;

    function new(string name="test_read", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
	
	wr_sq = axi_write_sequence::type_id::create("wr_sq");
        wr_sq.start(env.inp_agt.wr_sqr);

        rd_sq = axi_read_sequence::type_id::create("rd_sq");
        rd_sq.start(env.inp_agt.rd_sqr);

        phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////////////
class test_write_ro extends axi_test;
    `uvm_component_utils(test_write_ro)

    axi_write_ro_sequence wr_ro_sq;
    
    function new(string name="test_write_ro", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        wr_ro_sq = axi_write_ro_sequence::type_id::create("wr_ro_sq");
        wr_ro_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
////////////////////////////////////////////////////////////
class test_read_wo extends axi_test;
    `uvm_component_utils(test_read_wo)

    axi_read_wo_sequence rd_wo_sq;
    axi_write_wo_sequence wr_wo_sq;

    function new(string name="test_read_wo", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
	
	wr_wo_sq = axi_write_wo_sequence::type_id::create("wr_wo_sq");
        wr_wo_sq.start(env.inp_agt.wr_sqr);

        rd_wo_sq = axi_read_wo_sequence::type_id::create("rd_wo_sq");
        rd_wo_sq.start(env.inp_agt.rd_sqr);

        phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////////////////////
class test_write_unaligned extends axi_test;
    `uvm_component_utils(test_write_unaligned)

    axi_write_unaligned_sequence wr_unaligned_sq;

    function new(string name="test_write_unaligned", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        wr_unaligned_sq = axi_write_unaligned_sequence::type_id::create("wr_unaligned_sq");
        wr_unaligned_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
//////////////////////////////////////////////////////////////////
class write_addr_ob_test extends axi_test;
    `uvm_component_utils(write_addr_ob_test)

    axi_write_outofbound add_ob;

    function new(string name="write_addr_ob_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        add_ob = axi_write_outofbound::type_id::create("write_addr_ob_test");
        add_ob.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////////////////////
class test_read_unaligned extends axi_test;
    `uvm_component_utils(test_read_unaligned)

    axi_write_sequence wr_sq;
    axi_read_unaligned_sequence rd_unaligned_sq;

    function new(string name="test_read_unaligned", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

	wr_sq = axi_write_sequence::type_id::create("wr_sq");
        wr_sq.start(env.inp_agt.wr_sqr);

        rd_unaligned_sq = axi_read_unaligned_sequence::type_id::create("rd_unaligned_sq");
        rd_unaligned_sq.start(env.inp_agt.rd_sqr);

        phase.drop_objection(this);
    endtask
endclass
////////////////////////////////////////////////////////////////////////
class test_write_decerr extends axi_test;
    `uvm_component_utils(test_write_decerr)

    axi_write_decerr_sequence wr_decerr_sq;

    function new(string name="test_write_decerr", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        wr_decerr_sq = axi_write_decerr_sequence::type_id::create("wr_decerr_sq");
        wr_decerr_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
//////////////////////////////////////////////////////////////////////////////////////
class test_read_decerr extends axi_test;
    `uvm_component_utils(test_read_decerr)

    axi_read_decerr_sequence rd_decerr_sq;
    axi_write_sequence wr_sq;

    function new(string name="test_read_decerr", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

	wr_sq = axi_write_sequence::type_id::create("wr_sq");
        wr_sq.start(env.inp_agt.wr_sqr);	
	
        rd_decerr_sq = axi_read_decerr_sequence::type_id::create("rd_decerr_sq");
        rd_decerr_sq.start(env.inp_agt.rd_sqr);

        phase.drop_objection(this);
    endtask
endclass
//////////////////////////////////////////////////////////////////////////////////////
class test_write_coverage extends axi_test;
    `uvm_component_utils(test_write_coverage)

    axi_write_coverage_sequence wr_cov_sq;

    function new(string name="test_write_coverage", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        wr_cov_sq = axi_write_coverage_sequence::type_id::create("wr_cov_sq");
        wr_cov_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass

class test_awaddr_coverage extends axi_test;
    `uvm_component_utils(test_awaddr_coverage)

    axi_awaddr_coverage_sequence aw_cov_sq;

    function new(string name="test_awaddr_coverage", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        aw_cov_sq = axi_awaddr_coverage_sequence::type_id::create("aw_cov_sq");
        aw_cov_sq.start(env.inp_agt.wr_sqr);

        phase.drop_objection(this);
    endtask
endclass
////////////////////////////////////////////////////////////////////
class test_araddr_coverage extends axi_test;
    `uvm_component_utils(test_araddr_coverage)

    axi_araddr_coverage_sequence ar_cov_sq;

    function new(string name="test_araddr_coverage", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        ar_cov_sq = axi_araddr_coverage_sequence::type_id::create("ar_cov_sq");
        ar_cov_sq.start(env.inp_agt.rd_sqr);

        phase.drop_objection(this);
    endtask
endclass
////////////////////////////////////////////////////////////////////////////
class axi_write_da_test extends axi_test;
`uvm_component_utils(axi_write_da_test)

axi_write_sequence_da wr_da_sq;

function new(string name="axi_write_da_test", uvm_component parent);
	super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
	phase.raise_objection(this);

	wr_da_sq = axi_write_sequence_da::type_id::create("wr_da_sq");
	wr_da_sq.start(env.inp_agt.wr_sqr);

	phase.drop_objection(this);
endtask

endclass
///////////////////////////////////////////////////////////////////////
class axi_write_test_addr_after_data extends axi_test;
`uvm_component_utils(axi_write_test_addr_after_data)

function new(string name = "axi_write_test_addr_after_data", uvm_component parent);
  super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);

  axi_write_sequence_addr_after_data seq;

  phase.raise_objection(this);

  seq = axi_write_sequence_addr_after_data::type_id::create("seq");
  seq.start(env.inp_agt.wr_sqr);

  phase.drop_objection(this);

endtask

endclass
///////////////////////////////////////////////////////////////////////
class axi_write_both_test extends axi_test;
`uvm_component_utils(axi_write_both_test)

function new(string name="axi_write_both_test", uvm_component parent);
	super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
	axi_write_both_sequence seq;

	phase.raise_objection(this);

	seq = axi_write_both_sequence::type_id::create("seq");
	seq.start(env.inp_agt.wr_sqr);

	#100;

	phase.drop_objection(this);
endtask

endclass
