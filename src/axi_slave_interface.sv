interface axi_slave_interface(input bit ACLK, input bit ARESETn);

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
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY,BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
//input AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY, ARADDR, ARVALID, ARPROT, RREADY;
endclocking


clocking op_mon_cb@(posedge ACLK);
default input #1 output #0;
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY,BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
//input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
endclocking

modport DRV(clocking drv_cb);
modport IP_MON(clocking inp_mon_cb);
modport OP_MON(clocking op_mon_cb);

endinterfaceinterface axi_slave_interface(input bit ACLK, input bit ARESETn);

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
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY,BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
//input AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY, ARADDR, ARVALID, ARPROT, RREADY;
endclocking


clocking op_mon_cb@(posedge ACLK);
default input #1 output #0;
input AWADDR, AWPROT, AWVALID, AWREADY, WDATA, WSTRB, WVALID, WREADY,BREADY, BRESP, BVALID, ARADDR, ARVALID, ARPROT, ARREADY, RDATA, RRESP, RVALID, RREADY;
//input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
endclocking

modport DRV(clocking drv_cb);
modport IP_MON(clocking inp_mon_cb);
modport OP_MON(clocking op_mon_cb);

endinterface
