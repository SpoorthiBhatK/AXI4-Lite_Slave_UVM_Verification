`include "defines.sv"
`include "axi_slave_interface.sv"
`include "axi_slave_package.sv"
`include "axi_slave.sv"

module axi_slave_top();

import uvm_pkg::*;
import axi_slave_package::*;

bit CLK, RST;

axi_slave_interface duv_inf(CLK, RST);

axi_slave #() duv(
	.ACLK    (CLK),
	.ARESETn (RST),

	.AWADDR  (duv_inf.AWADDR),
	.AWPROT  (duv_inf.AWPROT),
	.AWVALID (duv_inf.AWVALID),
	.AWREADY (duv_inf.AWREADY),

	.WDATA   (duv_inf.WDATA),
	.WSTRB   (duv_inf.WSTRB),
	.WVALID  (duv_inf.WVALID),
	.WREADY  (duv_inf.WREADY),

	.BRESP   (duv_inf.BRESP),
	.BVALID  (duv_inf.BVALID),
	.BREADY  (duv_inf.BREADY),

	.ARADDR  (duv_inf.ARADDR),
	.ARPROT  (duv_inf.ARPROT),
	.ARVALID (duv_inf.ARVALID),
	.ARREADY (duv_inf.ARREADY),

	.RDATA   (duv_inf.RDATA),
	.RRESP   (duv_inf.RRESP),
	.RVALID  (duv_inf.RVALID),
	.RREADY  (duv_inf.RREADY)
);


// Clock generation
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end


// Active-low reset
initial begin
	RST = 1'b0;
	#20;
	RST = 1'b1;
end


// UVM configuration and test
initial begin

	$display("### TOP INITIAL START : time=%0t", $time);

	uvm_config_db #(virtual axi_slave_interface)::set(
		null,
		"*",
		"axi_slave_interface",
		duv_inf
	);

	$display("### AFTER CONFIG SET : time=%0t", $time);
	$dumpfile("waves.vcd");
	$dumpvars;

	run_test("test1");

	$display("### AFTER RUN_TEST : time=%0t", $time);

end


// Temporary safety timeout for debugging
initial begin
	#10000;
	$display("### SAFETY TIMEOUT : time=%0t", $time);
	$finish;
end

endmodule
