`include "defines.sv"

class axi_slave_sequence extends uvm_sequence #(axi_slave_seq_item);
`uvm_object_utils(axi_slave_sequence)

function new(string name = "axi_slave_sequence");
	super.new(name);
endfunction

task body();
	`uvm_info("SEQ","Sequence Body started", UVM_NONE)

/*
	repeat(5)begin
		write_seq();
	end

	#85;

	repeat(2)begin
		read_seq();
	end

	repeat(5)begin
		writeread_seq();
	end
*/

	write_seq_new();
  	$display("\n\nWrite done\n\nRead Start");
	read_seq_new();
  	$display("\n\nRead done");

	`uvm_info("SEQ","Sequence Body finished", UVM_NONE)
endtask

task write_seq_new();
	repeat(5)begin
		for(int i = 1; i <= 5; i++)begin
			req = axi_slave_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWVALID == 1;
				AWADDR  == i*4;
				WVALID  == 1;
              	WSTRB == 4'b1111;
				WDATA   == i;
				BREADY  == 1;
				ARVALID == 0;
				RREADY  == 0;
			});
			finish_item(req);
		end
	end
endtask

task read_seq_new();
	repeat(5)begin
		for(int i = 1; i <= 5; i++)begin
			req = axi_slave_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWVALID == 0;
				WVALID  == 0;
				BREADY  == 0;
				ARVALID == 1;
				ARADDR  == i*4;
				RREADY  == 1;
			});
			finish_item(req);
		end
	end
endtask

task write_seq();
	req = axi_slave_seq_item::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {
		AWVALID == 1;
		WVALID  == 1;
		BREADY  == 1;
		ARVALID == 0;
		RREADY  == 0;
	});
	finish_item(req);
endtask

task read_seq();
	req = axi_slave_seq_item::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {
		AWVALID == 0;
		WVALID  == 0;
		BREADY  == 0;
		ARVALID == 1;
		RREADY  == 1;
	});
	finish_item(req);
endtask

task writeread_seq();
	req = axi_slave_seq_item::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {
		AWVALID == 1;
		WVALID  == 1;
		BREADY  == 1;
		ARVALID == 1;
		RREADY  == 1;
	});
	finish_item(req);
endtask

endclass
