module slc3 (
	input  logic	    clk, 
	input  logic        reset, 

	// inputs should be synchronized in top level
	input  logic        run_i, 
	input  logic        continue_i,
	input  logic [15:0] sw_i,

	output logic [15:0] led_o,
	output logic [7:0]  hex_seg_o,
	output logic [3:0]  hex_grid_o,
	output logic [7:0]  hex_seg_debug,
	output logic [3:0]  hex_grid_debug,

	input  logic [15:0] sram_rdata,
	output logic [15:0] sram_wdata,
	output logic [15:0] sram_addr,
	output logic        sram_mem_ena, 
	output logic        sram_wr_ena
);

	logic [15:0] hex_display_debug;

	logic [15:0] cpu_rdata;
	logic [15:0] cpu_wdata;
	logic [15:0] cpu_addr;
	logic cpu_mem_ena;
	logic cpu_wr_ena;


	cpu cpu (
		.clk				(clk),
		.reset				(reset),

		.continue_i			(continue_i),
		.run_i				(run_i),
		.hex_display_debug	(hex_display_debug),
		.led_o				(led_o),

		.mem_rdata			(cpu_rdata),
		.mem_wdata			(cpu_wdata),
		.mem_addr			(cpu_addr),
		.mem_mem_ena		(cpu_mem_ena),
		.mem_wr_ena			(cpu_wr_ena)
	);

	cpu_to_io io_bridge ( 	
		.clk            (clk), 
		.reset          (reset),

		.cpu_addr       (cpu_addr), 
		.cpu_mem_ena    (cpu_mem_ena), 
		.cpu_wr_ena		(cpu_wr_ena),
		.cpu_wdata		(cpu_wdata),
		.cpu_rdata		(cpu_rdata),

		.sram_addr      (sram_addr), 
		.sram_mem_ena   (sram_mem_ena), 
		.sram_wr_ena	(sram_wr_ena),
		.sram_wdata		(sram_wdata),
		.sram_rdata		(sram_rdata),
	
		.sw_i			(sw_i),	
		.hex_grid_o		(hex_grid_o),
		.hex_seg_o 		(hex_seg_o)
	);


	hex_driver hex_debug (
		.clk        (clk),
		.reset      (reset),
		.in         ({hex_display_debug[15:12], 
					  hex_display_debug[11:8], 
					  hex_display_debug[7:4], 
					  hex_display_debug[3:0]}),

		.hex_seg    (hex_seg_debug),
		.hex_grid   (hex_grid_debug)
	);


	
endmodule
