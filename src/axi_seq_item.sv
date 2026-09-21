`include "defines.sv"
class axi_seq_item extends uvm_sequence_item;

//Write Address Channel
rand bit [`AW-1:0] AWADDR;
rand bit AWVALID;
rand bit [`DP-1:0] AWPROT;
bit AWREADY;

//Write Data Channel
rand bit [`DW-1:0] WDATA;
rand bit [`DW/8-1:0]WSTRB;
rand bit WVALID;
bit WREADY;
//Write Response Channel
rand bit BREADY;
bit [1:0] BRESP;
bit BVALID;

//Read Address Channel
rand bit [`AW-1:0] ARADDR;
rand bit [`DP-1:0] ARPROT;
rand bit ARVALID;
bit ARREADY;
//Read data channel
bit [`DW-1:0] RDATA;
bit [1:0] RRESP;
bit RVALID;
rand bit RREADY;

constraint cns
{
    AWPROT inside {[3'b000:3'b111]};
    ARPROT inside {[3'b000:3'b111]};
}

`uvm_object_utils_begin(axi_seq_item)

`uvm_field_int(AWADDR, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(AWPROT, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(AWVALID, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(AWREADY, UVM_ALL_ON | UVM_DEC)

`uvm_field_int(WDATA, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(WSTRB, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(WVALID, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(WREADY, UVM_ALL_ON | UVM_DEC)

`uvm_field_int(BREADY, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(BRESP, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(BVALID, UVM_ALL_ON | UVM_DEC)

`uvm_field_int(ARADDR, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(ARPROT, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(ARREADY, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(ARVALID, UVM_ALL_ON | UVM_DEC)

`uvm_field_int(RDATA, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(RRESP, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(RVALID, UVM_ALL_ON | UVM_DEC)
`uvm_field_int(RREADY, UVM_ALL_ON | UVM_DEC)
`uvm_object_utils_end

function new(string name = "axi_seq_item");
	super.new(name);
endfunction
endclass
