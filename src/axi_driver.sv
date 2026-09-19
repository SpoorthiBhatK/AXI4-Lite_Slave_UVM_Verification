`include "defines.sv" 
 
class axi_driver extends uvm_driver #(axi_seq_item);  
`uvm_component_utils(axi_driver)  
 
axi_config cfg;  
virtual axi_interface.DRV vif_drv;  
uvm_seq_item_pull_port #(axi_seq_item) rd_prt;  
 
bit aw_done; 
bit w_done; 
  
function new(string name = "axi_driver", uvm_component parent);  
  super.new(name, parent);  
  rd_prt = new("rd_prt", this);  
endfunction    
 
function void build_phase(uvm_phase phase);  
  super.build_phase(phase);  
 
  if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))  
    `uvm_fatal(get_type_name(), "Input_Driver config db get failed") 
 
  if(!uvm_config_db #(virtual axi_interface.DRV)::get(this,"","axi_drv_vif",vif_drv)) 
    `uvm_fatal(get_type_name(), "Driver VIF get failed") 
endfunction  
  
task run_phase(uvm_phase phase);  
  begin  
    `uvm_info("DRV","Sequence Body started", UVM_NONE)  
 
    repeat(3)@(vif_drv.drv_cb);  
    @(vif_drv.drv_cb);  
 
    fork  
      write_process();  
      read_process();  
    join_none  
  end  
endtask  
  
task write_process();   
 
  axi_seq_item data2duv;   
 
  aw_done = 0; 
  w_done  = 0; 
 
  forever begin   
 
    seq_item_port.get_next_item(data2duv);   
 
    if (data2duv.AWVALID && data2duv.WVALID) begin  
      fork  
        drive_aw(data2duv);  
        drive_w(data2duv);  
      join 
      aw_done = 1; 
      w_done  = 1; 
    end  
    else if (data2duv.AWVALID) begin  
      drive_aw(data2duv); 
      aw_done = 1; 
    end  
    else if (data2duv.WVALID) begin  
      drive_w(data2duv); 
      w_done = 1; 
 
      repeat(2) @(vif_drv.drv_cb); 
    end  
 
    seq_item_port.item_done(); 
 
    if (aw_done && w_done) begin 
      drive_b(data2duv); 
      aw_done = 0; 
      w_done  = 0; 
    end 
 
    repeat(2) @(vif_drv.drv_cb);   
  end   
endtask 
 
task read_process();  
 
  axi_seq_item data2duv;  
 
  forever begin  
 
    rd_prt.get_next_item(data2duv);  
 
    drive_ar(data2duv);  
    drive_r(data2duv);  
 
    rd_prt.item_done();  
 
  end  
endtask  
 
 
task drive_aw(axi_seq_item data2duv);  
 
  if(data2duv.AWVALID) begin  
 
    vif_drv.drv_cb.AWADDR  <= data2duv.AWADDR;  
    vif_drv.drv_cb.AWPROT  <= data2duv.AWPROT;  
    vif_drv.drv_cb.AWVALID <= 1'b1;  
 
    do @(vif_drv.drv_cb); while (!vif_drv.drv_cb.AWREADY);  
 
    `uvm_info("AXI_AW", $sformatf("AWADDR=%0h AWPROT=%0b AWVALID=%0b AWREADY=%0b", data2duv.AWADDR, data2duv.AWPROT, data2duv.AWVALID, vif_drv.drv_cb.AWREADY), UVM_NONE) 
 
    vif_drv.drv_cb.AWVALID <= 1'b0;  
 
  end  
endtask 
 
 
task drive_w(axi_seq_item data2duv);  
 
  if(data2duv.WVALID) begin  
 
    vif_drv.drv_cb.WDATA  <= data2duv.WDATA;  
    vif_drv.drv_cb.WSTRB  <= data2duv.WSTRB;  
    vif_drv.drv_cb.WVALID <= 1'b1;  
 
    do @(vif_drv.drv_cb); while (!vif_drv.drv_cb.WREADY);  
 
    `uvm_info("AXI_W", $sformatf("WDATA=%0h WSTRB=%0h WVALID=%0b WREADY=%0b", data2duv.WDATA, data2duv.WSTRB, data2duv.WVALID, vif_drv.drv_cb.WREADY), UVM_NONE) 
 
    vif_drv.drv_cb.WVALID <= 1'b0;  
 
  end  
endtask 
 
 
task drive_b(axi_seq_item data2duv);  
 
  if(data2duv.BREADY) begin  
 
    vif_drv.drv_cb.BREADY <= 1'b1;  
 
    do @(vif_drv.drv_cb); while (!vif_drv.drv_cb.BVALID);  
 
    `uvm_info("AXI_B", $sformatf("BREADY=%0b BVALID=%0b BRESP=%0b", data2duv.BREADY, vif_drv.drv_cb.BVALID, vif_drv.drv_cb.BRESP), UVM_NONE)  
 
    vif_drv.drv_cb.BREADY <= 1'b0;  
 
  end	  
endtask 
 
 
task drive_ar(axi_seq_item data2duv);  
 
  if(data2duv.ARVALID) begin  
 
    vif_drv.drv_cb.ARADDR  <= data2duv.ARADDR;  
    vif_drv.drv_cb.ARPROT  <= data2duv.ARPROT;  
    vif_drv.drv_cb.ARVALID <= 1'b1;  
 
    do @(vif_drv.drv_cb); while (!vif_drv.drv_cb.ARREADY);  
 
    `uvm_info("AXI_AR", $sformatf("ARADDR=%0h AWPROT=%0b ARVALID=%0b ARREADY=%0b", data2duv.ARADDR, data2duv.ARPROT, data2duv.ARVALID, vif_drv.drv_cb.ARREADY), UVM_NONE) 
 
    vif_drv.drv_cb.ARVALID <= 1'b0;  
 
  end  
endtask 
 
 
task drive_r(axi_seq_item data2duv);  
 
  if(data2duv.RREADY) begin  
 
    vif_drv.drv_cb.RREADY <= 1'b1;  
 
    do @(vif_drv.drv_cb); while (!vif_drv.drv_cb.RVALID);  
 
    `uvm_info("AXI_R", $sformatf("RREADY=%0b RVALID=%0b RRESP=%0b RDATA=%0h", data2duv.RREADY, vif_drv.drv_cb.RVALID, vif_drv.drv_cb.RRESP, vif_drv.drv_cb.RDATA), UVM_NONE) 
 
    vif_drv.drv_cb.RREADY <= 1'b0;  
 
  end  
endtask 
 
endclass
