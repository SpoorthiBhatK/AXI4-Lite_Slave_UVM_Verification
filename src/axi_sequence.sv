`include "defines.sv"

class axi_write_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_sequence)

	function new(string name="axi_write_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR[1:0] == 0;
				AWADDR < 32'h3C;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_wo_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_wo_sequence)

	function new(string name="axi_write_wo_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR inside {[32'h34:32'h38]};
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_read_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_read_sequence)

	function new(string name="axi_read_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				ARADDR[1:0] == 0;
				ARADDR < 32'h3C;
				//ARPROT == 3'b000;
				ARVALID == 1'b1;
				RREADY == 1'b1;
				AWVALID == 1'b0;
				WVALID == 1'b0;
				BREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_ro_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_ro_sequence)

	function new(string name="axi_write_ro_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR inside {[32'h28:32'h30]};
				AWPROT == 3'b000;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WDATA inside {[0:32'hFFFFFFFF]};
				//			WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_read_wo_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_read_wo_sequence)

	function new(string name="axi_read_wo_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				ARADDR inside {[32'h34:32'h38]};
				ARPROT == 3'b000;
				ARVALID == 1'b1;
				RREADY == 1'b1;
				AWVALID == 1'b0;
				WVALID == 1'b0;
				BREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_unaligned_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_unaligned_sequence)

	function new(string name="axi_write_unaligned_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				//			AWADDR > 32'h3C;
				AWPROT == 3'b000;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WDATA inside {[0:32'hFFFFFFFF]};
				//			WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_read_unaligned_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_read_unaligned_sequence)

	function new(string name="axi_read_unaligned_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(5) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				ARADDR[1:0] != 2'b00;
				ARPROT == 3'b000;
				ARVALID == 1'b1;
				RREADY == 1'b1;
				AWVALID == 1'b0;
				WVALID == 1'b0;
				BREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_decerr_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_decerr_sequence)

	function new(string name="axi_write_decerr_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(5) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR == 32'h00000100;
				AWPROT == 3'b000;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WDATA inside {[0:32'hFFFFFFFF]};
				//		WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_read_decerr_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_read_decerr_sequence)

	function new(string name="axi_read_decerr_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(5) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				ARADDR == 32'h00000100;
				ARPROT == 3'b000;
				ARVALID == 1'b1;
				RREADY == 1'b1;
				AWVALID == 1'b0;
				WVALID == 1'b0;
				BREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_coverage_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_coverage_sequence)

	function new(string name="axi_write_coverage_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(5) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR == 32'hFFFFFFFF;
				AWPROT == 3'b000;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WDATA == 32'hFFFFFFFF;
				//		WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
		#50;
	endtask
endclass

class axi_awaddr_coverage_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_awaddr_coverage_sequence)

	function new(string name="axi_awaddr_coverage_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;

		// AWADDR HIGH
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			AWADDR == 32'h80000000;
			AWPROT == 3'b000;
			AWVALID == 1'b1;
			WVALID == 1'b0;
			BREADY == 1'b0;
			ARVALID == 1'b0;
			RREADY == 1'b0;
		});
		finish_item(req);
		#50;
	endtask
endclass

class axi_araddr_coverage_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_araddr_coverage_sequence)

	function new(string name="axi_araddr_coverage_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;

		// ARADDR HIGH
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			ARADDR == 32'h80000000;
			ARPROT == 3'b000;
			ARVALID == 1'b1;
			RREADY == 1'b1;
			AWVALID == 1'b0;
			WVALID == 1'b0;
			BREADY == 1'b0;
		});
		finish_item(req);

		// ARADDR MAX
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			ARADDR == 32'hFFFFFFFF;
			ARPROT == 3'b000;
			ARVALID == 1'b1;
			RREADY == 1'b1;
			AWVALID == 1'b0;
			WVALID == 1'b0;
			BREADY == 1'b0;
		});
		finish_item(req);
		#50;
	endtask
endclass

class axi_write_sequence_da extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_sequence_da)

	function new(string name = "axi_write_sequence_da");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(50) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				//      WDATA   inside {[100:200]};
				//      WSTRB   == 4'hF;
				WVALID  == 1'b1;
				AWVALID == 1'b0;
				BREADY  == 1'b0;
				ARVALID == 1'b0;
				RREADY  == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR  inside {0,4,8};
				//      AWPROT  == 3'b000;
				AWVALID == 1'b1;
				WVALID  == 1'b0;
				BREADY  == 1'b1;
				ARVALID == 1'b0;
				RREADY  == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_sequence_addr_after_data extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_sequence_addr_after_data)

	function new(string name = "axi_write_sequence_addr_after_data");
		super.new(name);
	endfunction

	task body();
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			WDATA inside {[100:200]};
			//    WSTRB == 4'hF;
			WVALID == 1'b1;
			AWVALID == 1'b0;
			BREADY == 1'b1;
			ARVALID == 1'b0;
			RREADY == 1'b0;
		});
		finish_item(req);
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			AWADDR inside {0,4,8};
			AWPROT == 3'b000;
			AWVALID == 1'b1;
			WVALID == 1'b0;
			BREADY == 1'b1;
			ARVALID == 1'b0;
			RREADY == 1'b0;
		});
		finish_item(req);
	endtask
endclass

class axi_write_outofbound extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_outofbound)

	function new(string name="axi_write_unaligned_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		repeat(20) begin
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				AWADDR > 32'h3C;
				AWPROT == 3'b000;
				AWVALID == 1'b1;
				WVALID == 1'b0;
				BREADY == 1'b0;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
			req = axi_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				WDATA inside {[0:32'hFFFFFFFF]};
				//			WSTRB == 4'hF;
				WVALID == 1'b1;
				AWVALID == 1'b0;
				BREADY == 1'b1;
				ARVALID == 1'b0;
				RREADY == 1'b0;
			});
			finish_item(req);
		end
	endtask
endclass

class axi_write_both_sequence extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_write_both_sequence)

	function new(string name="axi_write_both_sequence");
		super.new(name);
	endfunction

	task body();
		axi_seq_item req;
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			AWVALID == 1'b1;
			WVALID  == 1'b1;
			BREADY  == 1'b1;
			ARVALID == 1'b0;
			RREADY  == 1'b0;
		});
		finish_item(req);
	endtask
endclass
