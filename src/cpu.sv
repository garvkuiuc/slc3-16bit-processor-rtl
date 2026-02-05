//------------------------------------------------------------------------------
//
// Create Date:    
// Module Name:    SLC3
//
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


logic ld_mar; 
logic ld_mdr; 
logic ld_ir; 
logic ld_pc; 
logic ld_led;
//logic tristate;

logic gate_pc;
logic gate_mdr;
logic gate_marmux;
logic gate_alu;

logic [1:0] pc_mux;

logic [15:0] mar; 
logic [15:0] mdr;
logic [15:0] ir;
logic [15:0] pc;
logic [15:0] alu;
logic ben;
logic [15:0] bus;

logic [15:0] pcin;

logic [1:0] addr2_mux;
logic addr1_mux;

logic [15:0] addr_input1;
logic [15:0] addr_input2;


logic [15:0] sr1_out;
logic [15:0] sr2_out;

logic ld_reg;
logic [15:0] mdr_in;


assign mem_addr = mar;
assign mem_wdata = mdr;
//assign tristate = {gate_pc, gate_mdr, gate_mar, gate_alu};


control cpu_control (
    .*
);

assign led_o = ir;
assign hex_display_debug = ir;

load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (bus),

    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pcin),

    .data_q(pc)
);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mdr),
    .data_i(mdr_in),

    .data_q(mdr)
);


load_reg #(.DATA_WIDTH(16)) mar_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mar),
    .data_i(bus),

    .data_q(mar)
);


tristate_mux mux(
    //.tristate(tristate),
    .gate_pc(gate_pc),
    .gate_mar(gate_marmux),
    .gate_mdr(gate_mdr),
    .gate_alu(gate_alu),
    .pc(pc),
    .mar(addr_input1+addr_input2),
    .mdr(mdr),
    .alu(alu),
    
    .q(bus)



);

three_to_one_multiplexer PC_MUX(

    .sel(pc_mux),
    .one(bus),
    .two(addr_input1+addr_input2),
    .three(pc+ 16'h0001),
    .q(pcin)
);

four_to_one addr2mux(
    .one({{5{ir[10]}}, ir[10:0]}),
    .two({{7{ir[8]}} ,ir[8:0]}),
    .three({{10{ir[5]}},ir[5:0]}),
    .four(16'h0000),
    
    .sel(addr2_mux),
    
    .q(addr_input1)


);

two_to_one_multiplexer addr1mux(
    .one(sr1_out),
    .two(pc),
    
    .sel(addr1_mux),
    
    .q(addr_input2)

);


logic [2:0] dr;
logic dr_mux;
two_to_one_multiplexer #(3) DR_mux(
    .one(ir[11:9]),
    .two(3'b111),
    
    .sel(dr_mux),
    
    .q(dr)

);


logic [2:0] sr1;
logic sr1_mux;
two_to_one_multiplexer #(3) SR1_mux(
    .one(ir[11:9]),
    .two(ir[8:6]),
    
    .sel(sr1_mux),
    
    .q(sr1)

);

logic [15:0] alu_inputB;
logic sr2_mux;

two_to_one_multiplexer SR2_mux(
    .one(sr2_out),
    .two({{11{ir[4]}},ir[4:0]}),
    
    .sel(sr2_mux),
    
    .q(alu_inputB)

);


logic [1:0] aluk;
ALU ALU(
    .one(sr1_out),
    .two(alu_inputB),
    
    .aluk(aluk),
    
    .q(alu)


);

logic ld_cc;

ben BRANCH(
    .bus(bus),
    .ir(ir),
    .ld_cc(ld_cc),
    .clk(clk),
    .reset(reset),
    .branch(ben)

);

logic mio_en;

two_to_one_multiplexer mdr_mux(
    .one(bus),
    .two(mem_rdata),
    
    .sel(mem_mem_ena),
    
    .q(mdr_in)

);
//two_to_one_multiplexer mdr_mux(
//    .one(bus),
//    .two(mem_rdata),
    
//    .sel(mio_en),
    
//    .q(mdr_in)

//);

logic [2:0] sr2;
assign sr2 = ir[2:0];

register REGISTER(

    .din(bus),
    .dr(dr),
    .ld_reg(ld_reg),
    .sr1(sr1),
    .sr2(sr2),
    .clk(clk),
    .reset(reset),
    
    .sr1_out(sr1_out),
    .sr2_out(sr2_out)

);



endmodule