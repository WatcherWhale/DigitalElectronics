// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Oct 28 12:05:15 2019
// Host        : DELLLAPTOPMAES running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Projects/DigitalElectronics/RandomDriehoeken/RandomDriehoeken.srcs/sources_1/new/TriangleFifo/TriangleFifo_stub.v
// Design      : TriangleFifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module TriangleFifo(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[58:0],wr_en,rd_en,dout[58:0],full,empty" */;
  input clk;
  input srst;
  input [58:0]din;
  input wr_en;
  input rd_en;
  output [58:0]dout;
  output full;
  output empty;
endmodule
