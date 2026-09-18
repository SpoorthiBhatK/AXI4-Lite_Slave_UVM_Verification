`include "defines.sv"

class axi_slave_subscriber extends uvm_subscriber #(axi_slave_seq_item);
`uvm_component_utils(axi_slave_subscriber)

axi_slave_seq_item drv;

covergroup inp_cg;

AWADDR_cp: coverpoint drv.AWADDR
{
	bins zero = {32'h00000000};
	bins max  = {32'hFFFFFFFF};
	bins low  = {[32'h00000001:32'h7FFFFFFF]};
	bins high = {[32'h80000000:32'hFFFFFFFE]};
}

AWPROT_cp: coverpoint drv.AWPROT
{
	bins zero = {3'b000};
	bins max  = {3'b111};
	bins low  = {[3'b001:3'b011]};
	bins high = {[3'b100:3'b110]};
}

AWVALID_cp: coverpoint drv.AWVALID
{
	bins md_low = {0};
	bins md_high = {1};
}

AWREADY_cp: coverpoint drv.AWREADY
{
	bins md_low = {0};
	bins md_high = {1};
}

WDATA_cp: coverpoint drv.WDATA
{
	bins zero = {32'h00000000};
	bins max  = {32'hFFFFFFFF};
	bins low  = {[32'h00000001:32'h7FFFFFFF]};
	bins high = {[32'h80000000:32'hFFFFFFFE]};
}

WSTRB_cp: coverpoint drv.WSTRB
{
	bins zero = {4'h0};
	bins max  = {4'hF};
	bins low  = {[4'h1:4'h7]};
	bins high = {[4'h8:4'hE]};
}

WVALID_cp: coverpoint drv.WVALID
{
	bins md_low = {0};
	bins md_high = {1};
}

WREADY_cp: coverpoint drv.WREADY
{
	bins md_low = {0};
	bins md_high = {1};
}

BRESP_cp: coverpoint drv.BRESP
{
	bins b[] = {[2'b00:2'b11]};
}

BVALID_cp: coverpoint drv.BVALID
{
	bins md_low = {0};
	bins md_high = {1};
}

BREADY_cp: coverpoint drv.BREADY
{
	bins md_low = {0};
	bins md_high = {1};
}

ARADDR_cp: coverpoint drv.ARADDR
{
	bins zero = {32'h00000000};
	bins max  = {32'hFFFFFFFF};
	bins low  = {[32'h00000001:32'h7FFFFFFF]};
	bins high = {[32'h80000000:32'hFFFFFFFE]};
}

ARPROT_cp: coverpoint drv.ARPROT
{
	bins zero = {3'b000};
	bins max  = {3'b111};
	bins low  = {[3'b001:3'b011]};
	bins high = {[3'b100:3'b110]};
}

ARVALID_cp: coverpoint drv.ARVALID
{
	bins md_low = {0};
	bins md_high = {1};
}

ARREADY_cp: coverpoint drv.ARREADY
{
	bins md_low = {0};
	bins md_high = {1};
}

RDATA_cp: coverpoint drv.RDATA
{
	bins zero = {32'h00000000};
	bins max  = {32'hFFFFFFFF};
	bins low  = {[32'h00000001:32'h7FFFFFFF]};
	bins high = {[32'h80000000:32'hFFFFFFFE]};
}

RRESP_cp: coverpoint drv.RRESP
{
	bins zero = {2'b00};
	ignore_bins max = {2'b01};
	bins low = {2'b10};
	bins high = {2'b11};
}

RVALID_cp: coverpoint drv.RVALID
{
	bins md_low = {0};
	bins md_high = {1};
}

RREADY_cp: coverpoint drv.RREADY
{
	bins md_low = {0};
	bins md_high = {1};
}

AW_HANDSHAKE: cross AWVALID_cp, AWREADY_cp;
W_HANDSHAKE:  cross WVALID_cp, WREADY_cp;
B_HANDSHAKE:  cross BVALID_cp, BREADY_cp;
AR_HANDSHAKE: cross ARVALID_cp, ARREADY_cp;
R_HANDSHAKE:  cross RVALID_cp, RREADY_cp;

endgroup

function new(string name, uvm_component parent);
	super.new(name, parent);
	inp_cg = new();
endfunction

virtual function void write(axi_slave_seq_item t);
	drv = t;
	inp_cg.sample();
	`uvm_info(get_name(),"[DRIVER]:INPUT RECIEVED",UVM_HIGH)
endfunction

function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info(get_name(),$sformatf("INPUT COVERAGE = %0f\n",inp_cg.get_coverage()),UVM_NONE);
endfunction

endclass
