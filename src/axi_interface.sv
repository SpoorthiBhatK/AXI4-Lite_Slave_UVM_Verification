interface axi_interface(input bit ACLK, input bit ARESETn);

//Write Address Channel
logic [`AW-1:0] AWADDR;
logic AWVALID;
logic [`DP-1:0] AWPROT;
logic AWREADY;
//Write Data Channel
logic [`DW-1:0] WDATA;
logic [`DW/8-1:0]WSTRB;
logic WVALID;
logic WREADY;
//Write Response Channel
logic BREADY;
logic [1:0] BRESP;
logic BVALID;

//Read Address Channel
logic [`AW-1:0] ARADDR;
logic [`DP-1:0] ARPROT;
logic ARVALID;
logic ARREADY;
//Read data channel
logic [`DW-1:0] RDATA;
logic [1:0] RRESP;
logic RVALID;
logic RREADY;
clocking drv_cb@(posedge ACLK);
default input #1 output #1;
output AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY, ARADDR, ARVALID, ARPROT, RREADY;
input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
endclocking

clocking inp_mon_cb@(posedge ACLK);
default input #1 output #0;
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY, BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
endclocking

clocking op_mon_cb@(posedge ACLK);
default input #1 output #0;
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY, BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
endclocking

property awvalid_stable;
	@(posedge ACLK) disable iff(!ARESETn)
		AWVALID && !AWREADY |=> AWVALID;
endproperty
assert property(awvalid_stable);

property wvalid_stable;
	@(posedge ACLK) disable iff(!ARESETn)
		WVALID && !WREADY |=> WVALID;
endproperty
assert property(wvalid_stable);

property bvalid_stable;
	@(posedge ACLK) disable iff(!ARESETn)
		BVALID && !BREADY |=> BVALID;
endproperty
assert property(bvalid_stable);

property arvalid_stable;
	@(posedge ACLK) disable iff(!ARESETn)
		ARVALID && !ARREADY |=> ARVALID;
endproperty
assert property(arvalid_stable);

property rvalid_stable;
	@(posedge ACLK) disable iff(!ARESETn)
		RVALID && !RREADY |=> RVALID;
endproperty
assert property(rvalid_stable);


/*
property p1;
	@(posedge ACLK) AWVALID && !AWREADY |=>$stable(AWADDR);
	endproperty
	assert property(p1)
	else
		$error("P1","Address not stable");
	property p2;
	@(posedge ACLK) WVALID && !WREADY |=>$stable(WDATA);
	endproperty
	assert property(p2)
	else
		$error ("P2","Data not stable");

	property p4;
	@(posedge ACLK) WVALID && !WREADY |=>$stable(WSTRB);
	endproperty
	assert property(p4)
	else
		$error ("P2","wstrb not stable");
	property p5;
	@(posedge ACLK) ARVALID && !ARREADY |=>$stable(ARADDR);
	endproperty
	assert property(p5)
	else
		$error ("P5","read address  not stable");
	property p6;
	@(posedge ACLK) ARVALID && !ARREADY |=>$stable(RDATA);
	endproperty
	assert property(p6)
	else
		$error ("P6","read data  not stable");
	property p7;
	@(posedge ACLK) BVALID && !BRESP |=>$stable(BRESP);
	endproperty
	assert property(p7)
	else
		$error("P7","Bresp not stable");
	property p8;
	@(posedge ACLK )ARVALID && ARREADY |->##[0:$] RVALID;
	endproperty
	assert property (p8)
	else
		$error("P8","rvalid came before");
 
*/
modport DRV(input ACLK, clocking drv_cb);
modport IP_MON(input ACLK, clocking inp_mon_cb);
modport OP_MON(input ACLK, clocking op_mon_cb);

endinterface
