// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sat Apr 27 18:48:47 2019
// Host        : DELLLAPTOPMAES running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/ip/clockGenerator/clockGenerator_stub.v
// Design      : clockGenerator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clockGenerator(CLKPixel, CLKGame, CLK100MHZ)
/* synthesis syn_black_box black_box_pad_pin="CLKPixel,CLKGame,CLK100MHZ" */;
  output CLKPixel;
  output CLKGame;
  input CLK100MHZ;
endmodule
