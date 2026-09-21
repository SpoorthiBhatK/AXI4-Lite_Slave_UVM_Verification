`include "defines.sv"

class axi_op_monitor extends uvm_monitor;
`uvm_component_utils(axi_op_monitor)

uvm_analysis_port #(axi_seq_item) op_m_port_write;
uvm_analysis_port #(axi_seq_item) op_m_port_read;

virtual axi_interface.OP_MON op_m_vif;
axi_config m_cfg;

function new(string name = "axi_op_monitor", uvm_component parent);
	super.new(name,parent);
	op_m_port_write = new("op_m_port_write",this);
	op_m_port_read = new("op_m_port_read",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(axi_config)::get(this,"","axi_config",m_cfg))
		`uvm_fatal(get_type_name(),"OP Mon get failed")
	if(!uvm_config_db #(virtual axi_interface.OP_MON)::get(this,"","axi_op_mon_vif",op_m_vif))
		`uvm_fatal(get_type_name(),"Output Monitor VIF get failed")
endfunction

task run_phase(uvm_phase phase);
	fork
		Write_collect();
		Read_collect();
	join_none
endtask
task Write_collect();
	axi_seq_item write_item;
	forever begin
		write_item = axi_seq_item::type_id::create("write_item");
		fork
			collect_aw(write_item);
			collect_w(write_item);
		join
		collect_b(write_item);
		op_m_port_write.write(write_item);
	end
endtask
task Read_collect();
	axi_seq_item read_item;
	forever begin
		read_item = axi_seq_item::type_id::create("read_item");
		collect_ar(read_item);
		collect_r(read_item);
		op_m_port_read.write(read_item);
	end
endtask
task collect_aw(axi_seq_item write_item);
	@(posedge op_m_vif.ACLK iff(op_m_vif.op_mon_cb.AWVALID && op_m_vif.op_mon_cb.AWREADY));
	write_item.AWVALID = op_m_vif.op_mon_cb.AWVALID;
	write_item.AWREADY = op_m_vif.op_mon_cb.AWREADY;
	write_item.AWADDR = op_m_vif.op_mon_cb.AWADDR;
	write_item.AWPROT = op_m_vif.op_mon_cb.AWPROT;
	`uvm_info("OP_AW",$sformatf("AWVALID=%0b AWREADY=%0b AWADDR=%0h AWPROT=%0b",op_m_vif.op_mon_cb.AWVALID,op_m_vif.op_mon_cb.AWREADY,op_m_vif.op_mon_cb.AWADDR,op_m_vif.op_mon_cb.AWPROT),UVM_NONE)
endtask

task collect_w(axi_seq_item write_item);
	@(posedge op_m_vif.ACLK iff(op_m_vif.op_mon_cb.WVALID && op_m_vif.op_mon_cb.WREADY));
	write_item.WVALID = op_m_vif.op_mon_cb.WVALID;
	write_item.WREADY = op_m_vif.op_mon_cb.WREADY;
	write_item.WDATA = op_m_vif.op_mon_cb.WDATA;
	write_item.WSTRB = op_m_vif.op_mon_cb.WSTRB;
	`uvm_info("OP_W",$sformatf("WVALID=%0b WREADY=%0b WDATA=%0h WSTRB=%0h",op_m_vif.op_mon_cb.WVALID,op_m_vif.op_mon_cb.WREADY,op_m_vif.op_mon_cb.WDATA,op_m_vif.op_mon_cb.WSTRB),UVM_NONE)
endtask

task collect_b(axi_seq_item write_item);
	@(posedge op_m_vif.ACLK iff(op_m_vif.op_mon_cb.BVALID && op_m_vif.op_mon_cb.BREADY));
	write_item.BVALID = op_m_vif.op_mon_cb.BVALID;
	write_item.BREADY = op_m_vif.op_mon_cb.BREADY;
	write_item.BRESP = op_m_vif.op_mon_cb.BRESP;
	`uvm_info("OP_B",$sformatf("BVALID=%0b BREADY=%0b BRESP=%0b",op_m_vif.op_mon_cb.BVALID,op_m_vif.op_mon_cb.BREADY,op_m_vif.op_mon_cb.BRESP),UVM_NONE)
endtask

task collect_ar(axi_seq_item read_item);
	@(posedge op_m_vif.ACLK iff(op_m_vif.op_mon_cb.ARVALID && op_m_vif.op_mon_cb.ARREADY));
	read_item.ARVALID = op_m_vif.op_mon_cb.ARVALID;
	read_item.ARREADY = op_m_vif.op_mon_cb.ARREADY;
	read_item.ARADDR = op_m_vif.op_mon_cb.ARADDR;
	read_item.ARPROT = op_m_vif.op_mon_cb.ARPROT;
	`uvm_info("OP_AR",$sformatf("ARVALID=%0b ARREADY=%0b ARADDR=%0h ARPROT=%0b",op_m_vif.op_mon_cb.ARVALID,op_m_vif.op_mon_cb.ARREADY,op_m_vif.op_mon_cb.ARADDR,op_m_vif.op_mon_cb.ARPROT),UVM_NONE)
endtask

task collect_r(axi_seq_item read_item);
	@(posedge op_m_vif.ACLK iff(op_m_vif.op_mon_cb.RVALID && op_m_vif.op_mon_cb.RREADY));
	read_item.RVALID = op_m_vif.op_mon_cb.RVALID;
	read_item.RREADY = op_m_vif.op_mon_cb.RREADY;
	read_item.RDATA = op_m_vif.op_mon_cb.RDATA;
	read_item.RRESP = op_m_vif.op_mon_cb.RRESP;
	`uvm_info("OP_R",$sformatf("RVALID=%0b RREADY=%0b RDATA=%0h RRESP=%0b",op_m_vif.op_mon_cb.RVALID,op_m_vif.op_mon_cb.RREADY,op_m_vif.op_mon_cb.RDATA,op_m_vif.op_mon_cb.RRESP),UVM_NONE)
endtask

endclass
