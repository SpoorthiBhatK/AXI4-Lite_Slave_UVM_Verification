`include "defines.sv"
`include "axi_interface.sv"
`include "axi_package.sv"
`include "axi_slave.sv"

module axi_top();

import uvm_pkg::*;
import axi_package::*;

bit CLK, RST;

axi_interface duv_inf(CLK, RST);

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

initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

initial begin
	RST = 1'b0;
	#20;
	RST = 1'b1;
	#1000;
	RST = 1'b0;
	#20;
	RST = 1'b1;
end
initial begin
	$display("### TOP INITIAL START : time=%0t", $time);
	uvm_config_db #(virtual axi_interface)::set(null,"*","axi_interface",duv_inf);
  	uvm_config_db #(virtual axi_interface.DRV)::set(null,"*","axi_drv_vif",duv_inf);
  	uvm_config_db #(virtual axi_interface.IP_MON)::set(null,"*","axi_inp_mon_vif",duv_inf);
	uvm_config_db #(virtual axi_interface.OP_MON)::set(null,"*","axi_op_mon_vif",duv_inf);
  	$display("### AFTER CONFIG SET : time=%0t", $time);
  	$dumpfile("waves.vcd");
  	$dumpvars;
  	run_test("axi_regression_test");
  	$display("### AFTER RUN_TEST : time=%0t", $time);
  	$finish;
end

endmodule
