// tb/test_bench_new.sv
`timescale 1ns/1ps
module test_bench_new;

  localparam time CLK_PERIOD = 20ns;       // 50 MHz
  localparam int  RESET_CYCLES = 8;
  localparam int  MAX_CYCLES   = 2_000_000;
  localparam int  MAX_COMMITS  = 5_000;

  logic        clk = 0, reset;
  logic        run_i, continue_i;
  logic [15:0] sw_i;
  logic [15:0] led_o;
  logic [7:0]  hex_seg_left, hex_seg_right;
  logic [3:0]  hex_grid_left, hex_grid_right;

  always #(CLK_PERIOD/2) clk = ~clk;

  task automatic apply_reset(int cycles = RESET_CYCLES);
    reset = 1; run_i = 0; continue_i = 0;
    repeat (cycles) @(posedge clk);
    reset = 0; @(posedge clk);
  endtask

  processor_top u_dut (
    .clk            (clk),
    .reset          (reset),
    .run_i          (run_i),
    .continue_i     (continue_i),
    .sw_i           (sw_i),
    .led_o          (led_o),
    .hex_seg_left   (hex_seg_left),
    .hex_grid_left  (hex_grid_left),
    .hex_seg_right  (hex_seg_right),
    .hex_grid_right (hex_grid_right)
  );

`ifdef HAS_COMMIT
  wire         commit_valid = u_dut.commit_valid;
  wire [15:0]  commit_pc    = u_dut.commit_pc;
  wire         wb_en        = u_dut.wb_en;
  wire  [2:0]  wb_rd        = u_dut.wb_rd;
  wire [15:0]  wb_data      = u_dut.wb_data;

  typedef struct packed { bit do_wb; logic [2:0] rd; logic [15:0] data; logic [15:0] pc; } commit_exp_t;
  function automatic commit_exp_t iss_step(input logic [15:0] pc);
    commit_exp_t c = '{default:0}; c.pc = pc; return c;
  endfunction
`endif

  task automatic press_run();
    @(posedge clk); run_i <= 1;
    @(posedge clk); run_i <= 0;
  endtask

  task automatic press_continue_n(int n);
    for (int i = 0; i < n; i++) begin
      @(posedge clk); continue_i <= 1;
      @(posedge clk); continue_i <= 0;
    end
  endtask

  function automatic [15:0] pick_switch_default();
    return 16'h009C;
  endfunction

  initial begin
    int cycle_cnt = 0;
`ifdef HAS_COMMIT
    int commit_cnt = 0, fail_cnt = 0;
`endif
    sw_i = pick_switch_default();
    int sw_val; if ($value$plusargs("SW=%d", sw_val)) sw_i = sw_val[15:0];

    apply_reset();
    press_run();

    while (cycle_cnt < MAX_CYCLES) begin
      @(posedge clk); cycle_cnt++;

`ifdef HAS_COMMIT
      if (commit_valid) begin
        commit_exp_t exp = iss_step(commit_pc);
        if ((commit_cnt % 1000) == 0) $display("[%0t] commit %0d @ PC=0x%04h", $time, commit_cnt, commit_pc);

        if (commit_pc !== exp.pc) begin
          $error("[PC] got=0x%04h exp=0x%04h", commit_pc, exp.pc);
          fail_cnt++;
        end

        // Uncomment when exp model is implemented:
        // if (wb_en !== exp.do_wb) begin $error("[WB_EN] @PC=0x%04h exp=%0b got=%0b", commit_pc, exp.do_wb, wb_en); fail_cnt++; end
        // if (wb_en && exp.do_wb && wb_rd !== exp.rd) begin $error("[RD] @PC=0x%04h exp=%0d got=%0d", commit_pc, exp.rd, wb_rd); fail_cnt++; end
        // if (wb_en && exp.do_wb && wb_data !== exp.data) begin $error("[DATA] @PC=0x%04h exp=0x%04h got=0x%04h", commit_pc, exp.data, wb_data); fail_cnt++; end

        commit_cnt++;
        if (commit_cnt >= MAX_COMMITS) begin
          $display("MAX_COMMITS=%0d reached. Fails=%0d Cycles=%0d", MAX_COMMITS, fail_cnt, cycle_cnt);
          $finish;
        end
      end
`endif
    end

    $display("Watchdog end. Cycles=%0d", cycle_cnt);
`ifdef HAS_COMMIT
    $display("Commits=%0d Fails=%0d", commit_cnt, fail_cnt);
`endif
    $finish;
  end

`ifdef BIND_ASSERTS
  property p_progress_led;
    @(posedge clk) disable iff (reset) run_i ##[1:10000] ($changed(led_o));
  endproperty
  assert property (p_progress_led)
    else $warning("No LED change within 10k cycles after RUN.");
`endif

endmodule
