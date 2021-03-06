// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Oct 28 12:18:47 2019
// Host        : DELLLAPTOPMAES running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Projects/DigitalElectronics/RandomDriehoeken/RandomDriehoeken.srcs/sources_1/new/ClockingWizzard/ClockingWizard_stub.v
// Design      : ClockingWizard
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ClockingWizard(PixelClk, Clk100MHz)
/* synthesis syn_black_box black_box_pad_pin="PixelClk,Clk100MHz" */;
  output PixelClk;
  input Clk100MHz;
endmodule
