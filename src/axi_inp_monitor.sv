`include "defines.sv"

class axi_inp_monitor extends uvm_monitor;
`uvm_component_utils(axi_inp_monitor)
  
uvm_analysis_port #(axi_seq_item) inp_m_port_write;
uvm_analysis_port #(axi_seq_item) inp_m_port_read;
  
virtual axi_interface.IP_MON ip_m_vif;
axi_config cfg;

function new(string name = "axi_inp_monitor", uvm_component parent);
	super.new(name,parent);
	inp_m_port_write = new("inp_monitor_port_write",this);
	inp_m_port_read = new("inp_monitor_port_read",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
		`uvm_fatal(get_type_name(),"Inp Mon get failed")

	if(!uvm_config_db #(virtual axi_interface.IP_MON)::get(this,"","axi_inp_mon_vif",ip_m_vif))
		`uvm_fatal(get_type_name(),"Input Monitor VIF get failed")
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
		inp_m_port_write.write(write_item);
	end
endtask

task Read_collect();
	axi_seq_item read_item;
	forever begin
		read_item = axi_seq_item::type_id::create("read_item");
		collect_ar(read_item);
		collect_r(read_item);
		inp_m_port_read.write(read_item);
	end
endtask
    
task collect_aw(axi_seq_item write_item);
	@(posedge ip_m_vif.ACLK iff (ip_m_vif.inp_mon_cb.AWVALID && ip_m_vif.inp_mon_cb.AWREADY));
	write_item.AWADDR = ip_m_vif.inp_mon_cb.AWADDR;
	write_item.AWPROT = ip_m_vif.inp_mon_cb.AWPROT;
	write_item.AWVALID = ip_m_vif.inp_mon_cb.AWVALID;
	write_item.AWREADY = ip_m_vif.inp_mon_cb.AWREADY;
	`uvm_info("AXI_AW",$sformatf("AWADDR=%0h AWPROT=%0b AWVALID=%0b AWREADY=%0b", write_item.AWADDR, write_item.AWPROT, write_item.AWVALID, ip_m_vif.inp_mon_cb.AWREADY), UVM_NONE)
endtask

task collect_w(axi_seq_item write_item);
	@(posedge ip_m_vif.ACLK iff (ip_m_vif.inp_mon_cb.WVALID && ip_m_vif.inp_mon_cb.WREADY));
	write_item.WDATA = ip_m_vif.inp_mon_cb.WDATA;
	write_item.WSTRB = ip_m_vif.inp_mon_cb.WSTRB;
	write_item.WVALID = ip_m_vif.inp_mon_cb.WVALID;
	write_item.WREADY = ip_m_vif.inp_mon_cb.WREADY;
	`uvm_info("AXI_W",$sformatf("WDATA=%0h WSTRB=%0h WVALID=%0b WREADY=%0b", write_item.WDATA, write_item.WSTRB, write_item.WVALID, ip_m_vif.inp_mon_cb.WREADY), UVM_NONE)
endtask

task collect_b(axi_seq_item write_item);
	@(posedge ip_m_vif.ACLK iff(ip_m_vif.inp_mon_cb.BVALID && ip_m_vif.inp_mon_cb.BREADY));
	write_item.BREADY = ip_m_vif.inp_mon_cb.BREADY;
	write_item.BVALID = ip_m_vif.inp_mon_cb.BVALID;
	write_item.BRESP = ip_m_vif.inp_mon_cb.BRESP;
	`uvm_info("AXI_B",$sformatf("BREADY=%0b BRESP=%0b BVALID=%0b", write_item.BREADY, ip_m_vif.inp_mon_cb.BRESP, ip_m_vif.inp_mon_cb.BVALID), UVM_NONE)
endtask
  
task collect_ar(axi_seq_item read_item);
	@(posedge ip_m_vif.ACLK iff (ip_m_vif.inp_mon_cb.ARVALID && ip_m_vif.inp_mon_cb.ARREADY));
	read_item.ARADDR = ip_m_vif.inp_mon_cb.ARADDR;
	read_item.ARPROT = ip_m_vif.inp_mon_cb.ARPROT;
	read_item.ARVALID = ip_m_vif.inp_mon_cb.ARVALID;
	read_item.ARREADY = ip_m_vif.inp_mon_cb.ARREADY;
	`uvm_info("AXI_AR",$sformatf("ARADDR=%0h ARPROT=%0b ARVALID=%0b ARREADY=%0b", read_item.ARADDR, read_item.ARPROT, read_item.ARVALID, ip_m_vif.inp_mon_cb.ARREADY), UVM_NONE)
endtask

task collect_r(axi_seq_item read_item);
	@(posedge ip_m_vif.ACLK iff(ip_m_vif.inp_mon_cb.RVALID && ip_m_vif.inp_mon_cb.RREADY));
	read_item.RREADY = ip_m_vif.inp_mon_cb.RREADY;
	read_item.RVALID = ip_m_vif.inp_mon_cb.RVALID;
	read_item.RDATA = ip_m_vif.inp_mon_cb.RDATA;
	read_item.RRESP = ip_m_vif.inp_mon_cb.RRESP;
	`uvm_info("AXI_R",$sformatf("RDATA=%0h RRESP=%0b RVALID=%0b RREADY=%0b", ip_m_vif.inp_mon_cb.RDATA, ip_m_vif.inp_mon_cb.RRESP, ip_m_vif.inp_mon_cb.RVALID, read_item.RREADY), UVM_NONE)
endtask

endclass
