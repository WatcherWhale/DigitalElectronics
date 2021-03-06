# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Projects/DigitalElectronics/project_1/project_1.cache/wt [current_project]
set_property parent.project_path C:/Projects/DigitalElectronics/project_1/project_1.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo c:/Projects/DigitalElectronics/project_1/project_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/new/AI.vhd
  C:/Projects/DigitalElectronics/Audio/Audio.srcs/sources_1/new/AudioDriver.vhd
  C:/Projects/DigitalElectronics/7SegmentController/7SegmentController.srcs/sources_1/new/BCDTo7SegmentConverter.vhd
  C:/Projects/DigitalElectronics/RedScreen/RedScreen.srcs/sources_1/new/HPulse.vhd
  C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/new/Player.vhd
  C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/new/Random.vhd
  C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/new/ScoreDisplay.vhd
  C:/Projects/DigitalElectronics/Counter/Counter.srcs/sources_1/new/Tick.vhd
  C:/Projects/DigitalElectronics/RedScreen/RedScreen.srcs/sources_1/new/VPulse.vhd
  C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/new/GameController.vhd
}
read_ip -quiet C:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/ip/clockGenerator/clockGenerator.xci
set_property used_in_implementation false [get_files -all c:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/ip/clockGenerator/clockGenerator_board.xdc]
set_property used_in_implementation false [get_files -all c:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/ip/clockGenerator/clockGenerator.xdc]
set_property used_in_implementation false [get_files -all c:/Projects/DigitalElectronics/project_1/project_1.srcs/sources_1/ip/clockGenerator/clockGenerator_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Projects/DigitalElectronics/project_1/project_1.srcs/constrs_1/new/Nexys-A7-100t-Master.xdc
set_property used_in_implementation false [get_files C:/Projects/DigitalElectronics/project_1/project_1.srcs/constrs_1/new/Nexys-A7-100t-Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top GameController -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef GameController.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file GameController_utilization_synth.rpt -pb GameController_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
