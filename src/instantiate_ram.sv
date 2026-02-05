`include "types.sv"
import SLC3_TYPES::*;

module instantiate_ram ( 
	input  logic 		reset,
	input 				clk,

	output logic [9:0]  addr,
	output logic 		wren,
	output logic [15:0] data
);
							
	 

    logic [15:0] mem_out;
	logic [15:0] address;
	logic init_mem;

	always_ff @(posedge clk) begin
		if (reset) begin
			init_mem <= 1'b1;
			address <= '0;
		end else begin

			if (init_mem) begin
				address <= address + 1'd1;
				
				if (address == 16'h00ff) begin
					init_mem <= 1'b0;
				end
			end

		end
	end
		
	assign wren = init_mem;
	assign data = memContents(address);
	assign addr = address[9:0];		

endmodule