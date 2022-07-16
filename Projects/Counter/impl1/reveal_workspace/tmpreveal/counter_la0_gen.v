//=============================================================================
// Verilog module generated by IPExpress    07/16/2022    21:51:44
// Filename: counter_la0.v
// Reveal IP core version: 1_6_042617
// Copyright(c) 2006 Lattice Semiconductor Corporation. All rights reserved.
//=============================================================================

/* WARNING - Changes to this file should be performed by re-running IPexpress
or modifying the .LPC file and regenerating the core.  Other changes may lead
to inconsistent simulation and/or implemenation results */

module counter_la0 (
    clk,
    reset_n,
    jtck,
    jrstn,
    jce2,
    jtdi,
    er2_tdo,
    jshift,
    jupdate,
    trigger_din_0,
    trace_din,
    sample_en,
    trigger_en,
    ip_enable
) /* synthesis GSR=DISABLED */ ;

// PARAMETERS DEFINED BY USER
localparam NUM_TRACE_SIGNALS   = 8;
localparam NUM_TRACE_SAMPLES   = 32;
localparam NUM_TRIGGER_SIGNALS = 1;
localparam MULTIPLE_CAPTURE    = 0;
localparam NUM_TRIG_MAX        = 1;
localparam SAMPLE_ENABLE       = 1;
localparam INVERT_SAMPLE_EN    = 0;
localparam GSR_ENABLE          = 0;
localparam INVERT_RESET        = 0;
localparam INCLUDE_TRIG_DATA   = 0;
localparam TM_EBR              = 1;
localparam DISABLE_DIST_RAM    = 0;
localparam NUM_TIME_STAMP_BITS = 0;
localparam NUM_TRIG_COUNT_BITS = 0;
localparam MIN_TRIG_OUT_PULSE  = 0;
localparam INVERT_TRIG_OUT     = 0;
localparam NUM_TU_BITS_0       = 1;
localparam REVEAL_SIG          = 423290744;
localparam REVEAL_VER          = 1_6_042617;
localparam LSCC_FAMILY         = "XP2";

input  clk;
input  reset_n;
input  jtck;
input  jrstn;
input  jce2;
input  jtdi;
output er2_tdo;
input  jshift;
input  jupdate;
input  [NUM_TU_BITS_0 -1:0] trigger_din_0;
input  [NUM_TRACE_SIGNALS + (NUM_TRIGGER_SIGNALS * INCLUDE_TRIG_DATA) -1:0] trace_din;
input  ip_enable;
input  sample_en;
input  trigger_en;

wire clear;
wire trigger;
wire wen;
wire ren;
wire wen_jtck;
wire ren_jtck;
wire [15:0] addr;
wire [15:0] wr_din;
wire [15:0] rd_dout_trig;
wire [15:0] rd_dout_tm;
wire [NUM_TIME_STAMP_BITS + NUM_TRACE_SIGNALS + (NUM_TRIGGER_SIGNALS * INCLUDE_TRIG_DATA) -1:0] trace_dout;
wire trace_dout_1st_bit;
wire parity_err;
wire even_parity;
wire capture_clk;
wire reset_rvl_n;
wire trigger_out;
wire tr_bit_0;
wire addr_15;
wire capture_dr;
wire [15:0] te_prog_din;
wire start_por;

assign reset_rvl_n = jrstn | ip_enable;

rvl_jtag_int #(
    .NUM_TRACE_SIGNALS   (NUM_TRACE_SIGNALS),
    .NUM_TRIGGER_SIGNALS (NUM_TRIGGER_SIGNALS),
    .INCLUDE_TRIG_DATA   (INCLUDE_TRIG_DATA),
    .NUM_TIME_STAMP_BITS (NUM_TIME_STAMP_BITS)
)
jtag_int_u(
    .clk            (clk),
    .reset_n        (reset_rvl_n),
    .jce2           (jce2),
    .jtdi           (jtdi),
    .jtdo           (er2_tdo),
    .jtck           (jtck),
    .jshift         (jshift),
    .jupdate        (jupdate),
    .jrstn          (jrstn),
    .ip_enable_bit  (ip_enable),
    .rd_dout_trig   (rd_dout_trig),
    .rd_dout_tm     (rd_dout_tm),
    .trace_dout     (trace_dout),
    .trace_dout_1st_bit     (trace_dout_1st_bit),
    .tr_bit_0       (tr_bit_0),
    .addr_15        (addr_15),
    .jshift_d1      (jshift_d1),
    .tt_prog_en_0   (tt_prog_en_0),
    .even_parity    (even_parity),
    .wen            (wen),
    .ren            (ren),
    .wen_jtck       (wen_jtck),
    .ren_jtck       (ren_jtck),
    .capture_clk    (capture_clk),
    .parity_err     (parity_err),
    .addr           (addr),
    .te_prog_din    (te_prog_din),
    .capture_dr     (capture_dr),
    .wr_din         (wr_din)
);

counter_la0_trig trig_u(
    .clk            (clk),
    .reset_n        (reset_rvl_n),
    .tu_in_0        (trigger_din_0),
    .wr_din         (wr_din),
    .rd_dout_trig   (rd_dout_trig),
    .addr           (addr),
    .ren            (ren),
    .wen            (wen),
    .wen_jtck       (wen_jtck),
    .capture_clk    (capture_clk),
    .clear          (clear),
    .parity_err     (parity_err),
    .te_prog_din    (te_prog_din),
    .ip_enable_bit  (ip_enable),
    .jtck           (jtck),
    .jrstn          (jrstn),
    .jshift         (jshift),
    .jshift_d1      (jshift_d1),
    .jce2           (jce2),
    .capture_dr     (capture_dr),
    .tt_prog_en_0   (tt_prog_en_0),
    .even_parity    (even_parity),
    .trigger        (trigger)
);

rvl_tm #(
    .NUM_TRACE_SIGNALS   (NUM_TRACE_SIGNALS),
    .NUM_TRACE_SAMPLES   (NUM_TRACE_SAMPLES),
    .NUM_TRIGGER_SIGNALS (NUM_TRIGGER_SIGNALS),
    .MULTIPLE_CAPTURE    (MULTIPLE_CAPTURE),
    .NUM_TRIG_MAX        (NUM_TRIG_MAX),
    .REVEAL_SIG          (REVEAL_SIG),
    .GSR_ENABLE          (GSR_ENABLE),
    .SAMPLE_ENABLE       (SAMPLE_ENABLE),
    .INVERT_SAMPLE_EN    (INVERT_SAMPLE_EN),
    .INCLUDE_TRIG_DATA   (INCLUDE_TRIG_DATA),
    .NUM_TIME_STAMP_BITS (NUM_TIME_STAMP_BITS),
    .NUM_TRIG_COUNT_BITS (NUM_TRIG_COUNT_BITS),
    .MIN_TRIG_OUT_PULSE  (MIN_TRIG_OUT_PULSE),
    .INVERT_TRIG_OUT     (INVERT_TRIG_OUT),
    .TM_EBR              (TM_EBR),
    .DISABLE_DIST_RAM    (DISABLE_DIST_RAM),
    .LSCC_FAMILY         (LSCC_FAMILY)
)
tm_u(
    .clk            (clk),
    .reset_n        (reset_rvl_n),
    .wen            (wen),
    .ren            (ren),
    .wen_jtck       (wen_jtck),
    .ren_jtck       (ren_jtck),
    .jtck           (jtck),
    .jrstn          (jrstn),
    .rd_dout_tm     (rd_dout_tm),
    .addr           (addr),
    .trigger        (trigger),
    .wr_din         (wr_din),
    .sample_en      (sample_en),
    .start_por      (start_por),
    .trace_din      (trace_din),
    .tr_bit_0       (tr_bit_0),
    .addr_15        (addr_15),
    .capture_dr     (capture_dr),
    .jshift         (jshift),
    .clear          (clear),
    .trace_dout     (trace_dout),
    .trace_dout_1st_bit     (trace_dout_1st_bit),
    .trigger_out    (trigger_out)
);

endmodule
