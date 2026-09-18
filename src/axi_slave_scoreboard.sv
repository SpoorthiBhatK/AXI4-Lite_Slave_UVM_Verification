`include "defines.sv"

class axi_slave_scoreboard extends uvm_scoreboard;

`uvm_component_utils(axi_slave_scoreboard)

uvm_tlm_analysis_fifo #(axi_slave_seq_item) ip_mon_fifo;
uvm_tlm_analysis_fifo #(axi_slave_seq_item) op_mon_fifo;

axi_slave_seq_item ip_data;
axi_slave_seq_item op_data;
  
  bit [`DW-1:0] aa [int];

function new(string name = "axi_slave_scoreboard", uvm_component parent);
	super.new(name, parent);
	ip_mon_fifo = new("ip_mon_fifo", this);
	op_mon_fifo = new("op_mon_fifo", this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  	forever begin
      ip_data = axi_slave_seq_item::type_id::create("ip_data");
	  op_data = axi_slave_seq_item::type_id::create("op_data");
      ip_mon_fifo.get(ip_data);
      op_mon_fifo.get(op_data);
	  generate_expected_op(ip_data);
      check_op(op_data);	
    end
endtask

  task generate_expected_op(axi_slave_seq_item t);
    write_chk(t);
    read_chk(t);
  endtask
  
  task write_chk(axi_slave_seq_item t);
    if(t.AWADDR > 32'h3C)
      t.BRESP = 2'b11;
    else if(t.AWADDR >= 32'h28 && t.AWADDR <= 32'h30)
      t.BRESP = 2'b10;
    else if(t.AWADDR[1:0] != 2'b00)
      t.BRESP = 2'b10;
    else begin
      t.BRESP = 2'b00;
      for(int i =0; i < 4; i++)begin
        if(t.WSTRB[i])
          aa[t.AWADDR[5:2]][i*8+:8] = t.WDATA[i*8+:8];
      end
    end
  endtask         
          
  task read_chk(axi_slave_seq_item t);
    if(t.AWADDR > 32'h3C)begin
      t.RRESP = 2'b11;
      t.RDATA = 0;
    end
    else if(t.ARADDR >= 32'h34 && t.ARADDR <= 32'h38)begin
      t.RRESP = 2'b10;
      t.RDATA = 0;
    end
    else if(t.ARADDR[1:0] != 2'b00)begin
      t.RRESP = 2'b10;
      t.RDATA = 0;
    end
    else begin
      t.RRESP = 2'b00;
      t.RDATA = aa[t.ARADDR[5:2]];
    end
  endtask
  
  task check_op(axi_slave_seq_item r);
    if(r.BRESP == ip_data.BRESP)begin
      `uvm_info(get_type_name(), $sformatf("BRESP Pass: Exp_BRESP: %d, Act_BRESP: %d", ip_data.BRESP, op_data.BRESP),UVM_NONE);
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("BRESP Fail: Exp_BRESP: %d, Act_BRESP: %d", ip_data.BRESP, op_data.BRESP),UVM_NONE);
    end  
    if(r.RDATA == ip_data.RDATA)begin
      `uvm_info(get_type_name(), $sformatf("RDATA Pass: Exp_RDATA: %d, Act_RDATA: %d", ip_data.RDATA, op_data.RDATA),UVM_NONE);
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("RDATA Fail: Exp_RDATA: %d, Act_RDATA: %d", ip_data.RDATA, op_data.RDATA),UVM_NONE);
    end
    if(r.RRESP == ip_data.RRESP)begin
      `uvm_info(get_type_name(), $sformatf("RRESP Pass: Exp_RRESP: %d, Act_RRESP: %d", ip_data.RRESP, op_data.RRESP),UVM_NONE);
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("RRESP Fail: Exp_RRESP: %d, Act_RRESP: %d", ip_data.RRESP, op_data.RRESP),UVM_NONE);
    end
    `uvm_info(get_type_name(), $sformatf("AW : AWADDR=%0d AWPROT=%0d AWVALID=%0d AWREADY=%0d", r.AWADDR, r.AWPROT, r.AWVALID, r.AWREADY), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("W  : WDATA=%0d WSTRB=%0d WVALID=%0d WREADY=%0d", r.WDATA, r.WSTRB, r.WVALID, r.WREADY), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("B  : BRESP=%0d BVALID=%0d BREADY=%0d", r.BRESP, r.BVALID, r.BREADY), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("AR : ARADDR=%0d ARPROT=%0d ARVALID=%0d ARREADY=%0d", r.ARADDR, r.ARPROT, r.ARVALID, r.ARREADY), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("R  : RDATA=%0d RRESP=%0d RVALID=%0d RREADY=%0d", r.RDATA, r.RRESP, r.RVALID, r.RREADY), UVM_NONE)
  endtask

endclass
