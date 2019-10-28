set_property SRC_FILE_INFO {cfile:c:/Projects/DigitalElectronics/RandomDriehoeken/RandomDriehoeken.srcs/sources_1/new/ClockingWizzard/ClockingWizard.xdc rfile:../../../RandomDriehoeken.srcs/sources_1/new/ClockingWizzard/ClockingWizard.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports Clk100MHz]] 0.1
