`include "defines.sv"

class axi_subscriber extends uvm_subscriber #(axi_seq_item);
`uvm_component_utils(axi_subscriber)

axi_seq_item drv;

covergroup inp_cg;

AWADDR_cp: coverpoint drv.AWADDR
{
	bins aw1 ={[32'h0:32'h24]};
	 bins aw2 = {[32'h28:32'h30], 'h3C};
//	 bins aw3 = {[32'h34:32'h3C]};
}

AWPROT_cp: coverpoint drv.AWPROT 
{
	ignore_bins prot = {[0:7]};
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
	bins wd1={[32'h0:32'h55555554]};
	bins wd2 = {[32'h55555555:32'hAAAAAAA9]};
	bins wd3 = {[32'hAAAAAAAA:32'hFFFFFFFF]};
}

WSTRB_cp: coverpoint drv.WSTRB
{
	bins max  = {4'hF};
	bins low  = {[4'h0:4'hE]};
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
	bins b[] = {2'b00,2'b10,2'b11};
	ignore_bins ib = {2'b01};
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
	bins ar1 ={[32'h0:32'h24]};
//	 bins ar2 = {[32'h28:32'h30], 32'h3C};
	 bins ar3 = {[32'h34:32'h3C]};
}

ARPROT_cp: coverpoint drv.ARPROT 
{
	ignore_bins prot = {[0:7]};
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
	bins wd1={[32'h0:32'hFFFFFFFF]};
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

AW_HANDSHAKE: cross AWVALID_cp, AWREADY_cp
{
	ignore_bins ib = (!binsof(AWVALID_cp) intersect {1'b1}) || (!binsof(AWREADY_cp) intersect {1'b1});
}
W_HANDSHAKE:  cross WVALID_cp, WREADY_cp
{
	ignore_bins ib = (!binsof(WVALID_cp) intersect {1'b1}) || (!binsof(WREADY_cp) intersect {1'b1});
}
B_HANDSHAKE:  cross BVALID_cp, BREADY_cp
{
	ignore_bins ib = (!binsof(BVALID_cp) intersect {1'b1}) || (!binsof(BREADY_cp) intersect {1'b1});
}
AR_HANDSHAKE: cross ARVALID_cp, ARREADY_cp
{
	ignore_bins ib = (!binsof(ARVALID_cp) intersect {1'b1}) || (!binsof(ARREADY_cp) intersect {1'b1});
}
R_HANDSHAKE:  cross RVALID_cp, RREADY_cp
{
	ignore_bins ib = (!binsof(RVALID_cp) intersect {1'b1}) || (!binsof(RREADY_cp) intersect {1'b1});
}
endgroup

function new(string name, uvm_component parent);
	super.new(name, parent);
	inp_cg = new();
endfunction

virtual function void write(axi_seq_item t);
	drv = t;
	inp_cg.sample();
	`uvm_info(get_name(),"[DRIVER]:INPUT RECIEVED",UVM_HIGH)
endfunction

function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info(get_name(),$sformatf("INPUT COVERAGE = %0f\n",inp_cg.get_coverage()),UVM_NONE);
endfunction

endclass
