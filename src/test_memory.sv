// This file is for simulations only. 
`include "types.sv"
import SLC3_TYPES::*;

module test_memory ( 
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] data,
    input  logic [9:0]  address,
    input  logic	    ena,
    input  logic	    wren,
    output logic [15:0] readout
);
												
// synthesis translate_off
// This line turns off Quartus/Vivado' synthesis tool because test memory is NOT synthesizable.
// Notice that even though the above line is commented, it will still take into effect!


    parameter size          = 256; 
    parameter init_external = 0;   
    integer ptr;
    integer x;

    logic [15:0] mem_array [0:size-1];
    logic [15:0] mem_out;


    


    initial begin      
        // Parse into machine code and write into file
        if (~init_external) begin
            ptr = $fopen("memory_contents.mif", "w");
            
            for (integer x = 0; x < size; x++) begin
                $fwrite(ptr, "@%0h %0h\n", x, memContents(x[15:0]));
            end
            
            $fclose(ptr);
        end

        $readmemh("memory_contents.mif", mem_array, 0, size-1);
    end
    
    // Memory read logic
    always @(posedge clk) begin
	    if(reset) begin
            $readmemh("memory_contents.mif", mem_array, 0, size-1);
				mem_out <= 16'bxxxxxxxxxxxxxxxx;
        end else if(ena & ~wren) begin
				mem_out <= mem_array[address[7:0]]; // Read a specific memory cell. 
        // Flip-flop with negedge Clk is used to simulate the 10ns access time.
        // (Assuming address changes at rising clock edge)
		end else if(ena & wren) begin
            mem_array[address[7:0]] <= data;
			mem_out <= 16'bxxxxxxxxxxxxxxxx;
		end else begin
			mem_out <= 16'bxxxxxxxxxxxxxxxx;
		end
    end
    

	assign readout = mem_out;
    

// synthesis translate_on
endmodule