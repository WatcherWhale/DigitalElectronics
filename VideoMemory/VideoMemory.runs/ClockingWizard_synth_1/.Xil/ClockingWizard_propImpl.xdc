set_property SRC_FILE_INFO {cfile:c:/Projects/DigitalElectronics/VideoMemory/VideoMemory.srcs/sources_1/ip/ClockingWizzard/ClockingWizard.xdc rfile:../../../VideoMemory.srcs/sources_1/ip/ClockingWizzard/ClockingWizard.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports Clk100MHz]] 0.1
