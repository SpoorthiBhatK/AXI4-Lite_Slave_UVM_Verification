`include "defines.sv"

class axi_scoreboard extends uvm_scoreboard;
`uvm_component_utils(axi_scoreboard)

uvm_tlm_analysis_fifo #(axi_seq_item) ip_mon_fifo_write;
uvm_tlm_analysis_fifo #(axi_seq_item) ip_mon_fifo_read;
uvm_tlm_analysis_fifo #(axi_seq_item) op_mon_fifo_write;
uvm_tlm_analysis_fifo #(axi_seq_item) op_mon_fifo_read;

axi_seq_item ip_write_data;
axi_seq_item ip_read_data;
axi_seq_item op_write_data;
axi_seq_item op_read_data;

bit [`DW-1:0] aa [int];

function new(string name = "axi_scoreboard",uvm_component parent);
	super.new(name,parent);
	ip_mon_fifo_write = new("ip_mon_fifo_write",this);
	ip_mon_fifo_read = new("ip_mon_fifo_read",this);
	op_mon_fifo_write = new("op_mon_fifo_write",this);
	op_mon_fifo_read = new("op_mon_fifo_read",this);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
  	for(int i = 0;i < 16;i++)
    		aa[i] = '0;
endfunction
task run_phase(uvm_phase phase);
	fork
		write_compare();
		read_compare();
  	join
endtask

task write_compare();
	forever begin
		ip_mon_fifo_write.get(ip_write_data);
		`uvm_info("SCB",$sformatf("%h",ip_write_data.WSTRB),UVM_NONE);
		generate_expected_write(ip_write_data);
    		op_mon_fifo_write.get(op_write_data);
    		check_write(op_write_data,ip_write_data);
  	end
endtask
task read_compare();
	forever begin
    		ip_mon_fifo_read.get(ip_read_data);
    		generate_expected_read(ip_read_data);
    		op_mon_fifo_read.get(op_read_data);
    		check_read(op_read_data,ip_read_data);
  	end
endtask
task generate_expected_write(axi_seq_item t);
	if(t.AWVALID && t.WVALID)
		write_chk(t);
endtask
task generate_expected_read(axi_seq_item t);
	if(t.ARVALID)
		read_chk(t);
endtask
task write_chk(axi_seq_item t);
	if(t.AWADDR > 32'h3C)
    		t.BRESP = 2'b11;
  	else if(t.AWADDR >= 32'h28 && t.AWADDR <= 32'h30)
    		t.BRESP = 2'b10;
  	else if(t.AWADDR[1:0] != 2'b00)
    		t.BRESP = 2'b10;
  	else begin
    		t.BRESP = 2'b00;
    		for(int i = 0;i < 4;i++) begin
      			if(t.WSTRB[i])
        		aa[t.AWADDR/4][i*8+:8] = t.WDATA[i*8+:8];
    		end
  	end
endtask

task read_chk(axi_seq_item t);
	if(t.ARADDR > 32'h3C) begin
    		t.RRESP = 2'b11;
    		t.RDATA = '0;
  	end
  	else if(t.ARADDR >= 32'h34 && t.ARADDR <= 32'h38) begin
    		t.RRESP = 2'b10;
    		t.RDATA = '0;
  	end
  	else if(t.ARADDR[1:0] != 2'b00) begin
    		t.RRESP = 2'b10;
    		t.RDATA = '0;
  	end
  	else begin
    		t.RRESP = 2'b00;
    		t.RDATA = aa[t.ARADDR/4];
  	end
endtask
task check_write(axi_seq_item actual,axi_seq_item expected);
	if(actual.AWADDR == expected.AWADDR)
 		`uvm_info("SCB",$sformatf("WRITE ADDRESS PASS: Exp_AWADDR=%0h Actual_AWADDR=%0h",expected.AWADDR,actual.AWADDR),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("WRITE ADDRESS FAIL: Exp_AWADDR=%0h Actual_AWADDR=%0h",expected.AWADDR,actual.AWADDR))
	if(actual.WDATA == expected.WDATA)
    		`uvm_info("SCB",$sformatf("WRITE DATA PASS: Exp_WDATA=%0h Actual_WDATA=%0h",expected.WDATA,actual.WDATA),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("WRITE DATA FAIL: Exp_WDATA=%0h Actual_WDATA=%0h",expected.WDATA,actual.WDATA))
  	if(actual.WSTRB == expected.WSTRB)
    		`uvm_info("SCB",$sformatf("WRITE WSTRB PASS: Exp_WSTRB=%0h Actual_WSTRB=%0h",expected.WSTRB,actual.WSTRB),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("WRITE WSTRB FAIL: Exp_WSTRB=%0h Actual_WSTRB=%0h",expected.WSTRB,actual.WSTRB))
  	if(actual.BRESP == expected.BRESP)
    		`uvm_info("SCB",$sformatf("WRITE BRESP PASS: Exp_BRESP=%0b Actual_BRESP=%0b",expected.BRESP,actual.BRESP),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("WRITE BRESP FAIL: Exp_BRESP=%0b Actual_BRESP=%0b",expected.BRESP,actual.BRESP))
endtask
task check_read(axi_seq_item actual,axi_seq_item expected);
	if(actual.ARADDR == expected.ARADDR)
    		`uvm_info("SCB",$sformatf("READ ADDRESS PASS: Exp_ARADDR=%0h Actual_ARADDR=%0h",expected.ARADDR,actual.ARADDR),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("READ ADDRESS FAIL: Exp_ARADDR=%0h Actual_ARADDR=%0h",expected.ARADDR,actual.ARADDR))

  	if(actual.RDATA == expected.RDATA)
    		`uvm_info("SCB",$sformatf("READ DATA PASS: Exp_RDATA=%0h Actual_RDATA=%0h",expected.RDATA,actual.RDATA),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("READ DATA FAIL: Exp_RDATA=%0h Actual_RDATA=%0h",expected.RDATA,actual.RDATA))
 	if(actual.RRESP == expected.RRESP)
    		`uvm_info("SCB",$sformatf("READ RRESP PASS: Exp_RRESP=%0b Actual_RRESP=%0b",expected.RRESP,actual.RRESP),UVM_NONE)
  	else
    		`uvm_error("SCB",$sformatf("READ RRESP FAIL: Exp_RRESP=%0b Actual_RRESP=%0b",expected.RRESP,actual.RRESP))
endtask

endclass
