`include "defines.sv"

class axi_slave_driver extends uvm_driver #(axi_slave_seq_item);
`uvm_component_utils(axi_slave_driver)
  
axi_slave_config cfg;
virtual axi_slave_interface vif_drv;


  function new(string name = "axi_slave_driver", uvm_component parent);
	super.new(name, parent);
endfunction  
  
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(axi_slave_config)::get(this,"","axi_slave_config",cfg))
		`uvm_fatal(get_type_name(), "Input_Driver config db get failed")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif_drv = cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	begin
      `uvm_info("DRV","Sequence Body started", UVM_NONE)
	repeat(3)@(vif_drv.drv_cb);
	forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();	
		end
	end
endtask

task drive(axi_slave_seq_item data2duv);
begin
  @(vif_drv.drv_cb);
	fork
		begin
			fork
			drive_aw(data2duv);
			drive_w(data2duv);
			join
		drive_b(data2duv);
		end
		begin
			drive_ar(data2duv);
      		drive_r(data2duv);
		end
	join
end
endtask

task drive_aw(axi_slave_seq_item data2duv);
	if(data2duv.AWVALID) begin
		vif_drv.drv_cb.AWADDR  <= data2duv.AWADDR;
		vif_drv.drv_cb.AWPROT  <= data2duv.AWPROT;
		vif_drv.drv_cb.AWVALID <= 1'b1;
		do begin
			@(vif_drv.drv_cb);
		end
		while (!vif_drv.drv_cb.AWREADY);
      		`uvm_info("AXI_AW", $sformatf("AWADDR=%0h AWPROT=%0b AWVALID=%0b AWREADY=%0b", data2duv.AWADDR, data2duv.AWPROT, data2duv.AWVALID, vif_drv.drv_cb.AWREADY), UVM_NONE)
      	@(vif_drv.drv_cb);
		vif_drv.drv_cb.AWVALID <= 1'b0;
	end
	else begin
		vif_drv.drv_cb.AWVALID <= 1'b0;
	end
endtask
task drive_w(axi_slave_seq_item data2duv);
	if(data2duv.WVALID) begin
		vif_drv.drv_cb.WDATA  <= data2duv.WDATA;
		vif_drv.drv_cb.WSTRB  <= data2duv.WSTRB;
		vif_drv.drv_cb.WVALID <= 1'b1;
		do begin
			@(vif_drv.drv_cb);
		end
		while (!vif_drv.drv_cb.WREADY);
      
        	`uvm_info("AXI_W",  $sformatf("WDATA=%0h WSTRB=%0h WVALID=%0b WREADY=%0b", data2duv.WDATA, data2duv.WSTRB, data2duv.WVALID, vif_drv.drv_cb.WREADY), UVM_NONE)
      	@(vif_drv.drv_cb);
		vif_drv.drv_cb.WVALID <= 1'b0;
	end
	else begin
		vif_drv.drv_cb.WVALID <= 1'b0;
	end
endtask

  
task drive_b(axi_slave_seq_item data2duv);
	if(data2duv.BREADY) begin
		vif_drv.drv_cb.BREADY <= 1'b1;
		do begin
			@(vif_drv.drv_cb);
		end
		while (!vif_drv.drv_cb.BVALID);	
		
		data2duv.BVALID = vif_drv.drv_cb.BVALID;
		data2duv.BRESP  = vif_drv.drv_cb.BRESP;
		
      	`uvm_info("AXI_B",  $sformatf("BREADY=%0b BVALID=%0b BRESP=%0b", data2duv.BREADY, vif_drv.drv_cb.BVALID, vif_drv.drv_cb.BRESP), UVM_NONE)
      	@(vif_drv.drv_cb);
      
      	vif_drv.drv_cb.BREADY <= 1'b0;
	
end	else begin
		vif_drv.drv_cb.BREADY <= 1'b0;
	end
endtask


task drive_ar(axi_slave_seq_item data2duv);
	if(data2duv.ARVALID) begin
		vif_drv.drv_cb.ARADDR  <= data2duv.ARADDR;
		vif_drv.drv_cb.ARPROT  <= data2duv.ARPROT;
		vif_drv.drv_cb.ARVALID <= 1'b1;
		do begin
			@(vif_drv.drv_cb);
		end
		while (!vif_drv.drv_cb.ARREADY);
      		`uvm_info("AXI_AR", $sformatf("ARADDR=%0h ARPROT=%0b ARVALID=%0b ARREADY=%0b", data2duv.ARADDR, data2duv.ARPROT, data2duv.ARVALID, vif_drv.drv_cb.ARREADY), UVM_NONE)
      	@(vif_drv.drv_cb);
		vif_drv.drv_cb.ARVALID <= 1'b0;
	end
	else begin
		vif_drv.drv_cb.ARVALID <= 1'b0;
	end
endtask
task drive_r(axi_slave_seq_item data2duv);
	if(data2duv.RREADY) begin
		vif_drv.drv_cb.RREADY <= 1'b1;
		do begin
			@(vif_drv.drv_cb);
		end
		while (!vif_drv.drv_cb.RVALID);
			`uvm_info("AXI_R",  $sformatf("RREADY=%0b RVALID=%0b RDATA=%0h RRESP=%0b", data2duv.RREADY, vif_drv.drv_cb.RVALID, data2duv.RDATA, data2duv.RRESP), UVM_NONE)
		data2duv.RVALID = vif_drv.drv_cb.RVALID;
		data2duv.RDATA  = vif_drv.drv_cb.RDATA;
		data2duv.RRESP  = vif_drv.drv_cb.RRESP;
      	@(vif_drv.drv_cb);
		vif_drv.drv_cb.RREADY <= 1'b0;
	end
	else begin
		vif_drv.drv_cb.RREADY <= 1'b0;
	end
endtask
endclass		
		






