`include "defines.sv"
class axi_slave_op_monitor extends uvm_monitor;
`uvm_component_utils(axi_slave_op_monitor)
uvm_analysis_port #(axi_slave_seq_item) op_m_port;
virtual axi_slave_interface op_m_vif;
axi_slave_config m_cfg;

function new(string name = "axi_slave_op_monitor", uvm_component parent);
	super.new(name,parent);
	op_m_port = new("op_monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(axi_slave_config)::get(this,"","axi_slave_config",m_cfg))
		`uvm_fatal(get_type_name(),"OP Mon get failed")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	op_m_vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
  repeat(7) @(op_m_vif.op_mon_cb);
	fork
		collect_aw();
		collect_w();
		collect_b();
		collect_ar();
		collect_r();
	join
endtask

task collect_aw();
	axi_slave_seq_item aw_item;
	forever begin
		@(op_m_vif.op_mon_cb);
		if(op_m_vif.op_mon_cb.AWVALID && op_m_vif.op_mon_cb.AWREADY) begin
			aw_item = axi_slave_seq_item::type_id::create("aw_item");
			aw_item.AWADDR = op_m_vif.op_mon_cb.AWADDR;
			aw_item.AWPROT = op_m_vif.op_mon_cb.AWPROT;
			aw_item.AWVALID = op_m_vif.op_mon_cb.AWVALID;
			aw_item.AWREADY = op_m_vif.op_mon_cb.AWREADY;
			op_m_port.write(aw_item);
			`uvm_info("AXI_AW",$sformatf("AWADDR=%0h AWPROT=%0b AWVALID=%0b AWREADY=%0b",aw_item.AWADDR,aw_item.AWPROT,aw_item.AWVALID,aw_item.AWREADY),UVM_NONE)
		end
	end
endtask

task collect_w();
	axi_slave_seq_item w_item;
	forever begin
		@(op_m_vif.op_mon_cb);
		if(op_m_vif.op_mon_cb.WVALID && op_m_vif.op_mon_cb.WREADY) begin
			w_item = axi_slave_seq_item::type_id::create("w_item");
			w_item.WDATA = op_m_vif.op_mon_cb.WDATA;
			w_item.WSTRB = op_m_vif.op_mon_cb.WSTRB;
			w_item.WVALID = op_m_vif.op_mon_cb.WVALID;
			w_item.WREADY = op_m_vif.op_mon_cb.WREADY;
			op_m_port.write(w_item);
			`uvm_info("AXI_W",$sformatf("WDATA=%0h WSTRB=%0h WVALID=%0b WREADY=%0b",w_item.WDATA,w_item.WSTRB,w_item.WVALID,w_item.WREADY),UVM_NONE)
		end
	end
endtask

task collect_b();
	axi_slave_seq_item b_item;
	forever begin
		@(op_m_vif.op_mon_cb);
		if(op_m_vif.op_mon_cb.BVALID && op_m_vif.op_mon_cb.BREADY) begin
			b_item = axi_slave_seq_item::type_id::create("b_item");
			b_item.BREADY = op_m_vif.op_mon_cb.BREADY;
			b_item.BVALID = op_m_vif.op_mon_cb.BVALID;
			b_item.BRESP = op_m_vif.op_mon_cb.BRESP;
			op_m_port.write(b_item);
			`uvm_info("AXI_B",$sformatf("BREADY=%0b BVALID=%0b BRESP=%0b",b_item.BREADY,b_item.BVALID,b_item.BRESP),UVM_NONE)
		end
	end
endtask

task collect_ar();
	axi_slave_seq_item ar_item;
	forever begin
		@(op_m_vif.op_mon_cb);
		if(op_m_vif.op_mon_cb.ARVALID && op_m_vif.op_mon_cb.ARREADY) begin
			ar_item = axi_slave_seq_item::type_id::create("ar_item");
			ar_item.ARADDR = op_m_vif.op_mon_cb.ARADDR;
			ar_item.ARPROT = op_m_vif.op_mon_cb.ARPROT;
			ar_item.ARVALID = op_m_vif.op_mon_cb.ARVALID;
			ar_item.ARREADY = op_m_vif.op_mon_cb.ARREADY;
			op_m_port.write(ar_item);
			`uvm_info("AXI_AR",$sformatf("ARADDR=%0h ARPROT=%0b ARVALID=%0b ARREADY=%0b",ar_item.ARADDR,ar_item.ARPROT,ar_item.ARVALID,ar_item.ARREADY),UVM_NONE)
		end
	end
endtask

task collect_r();
	axi_slave_seq_item r_item;
	forever begin
		@(op_m_vif.op_mon_cb);
		if(op_m_vif.op_mon_cb.RVALID && op_m_vif.op_mon_cb.RREADY) begin
			r_item = axi_slave_seq_item::type_id::create("r_item");
			r_item.RREADY = op_m_vif.op_mon_cb.RREADY;
			r_item.RVALID = op_m_vif.op_mon_cb.RVALID;
			r_item.RDATA = op_m_vif.op_mon_cb.RDATA;
			r_item.RRESP = op_m_vif.op_mon_cb.RRESP;
			op_m_port.write(r_item);
			`uvm_info("AXI_R",$sformatf("RDATA=%0h RRESP=%0b RVALID=%0b RREADY=%0b",r_item.RDATA,r_item.RRESP,r_item.RVALID,r_item.RREADY),UVM_NONE)
		end
	end
endtask
endclass
