set path_to_library C:/intelFPGA_lite/18.1/quartus/eda/sim_lib
vlib work

set source_file {
  "../../rtl/fifo/fifo.sv"
  "top_tb.sv"
}

#set source_file {
#  "scfifo_tb.sv"
#}

vlog $path_to_library/altera_mf.v

foreach files $source_file {
  vlog -sv $files
}

#Return the name of last file (without extension .sv)
set fbasename [file rootname [file tail [lindex $source_file end]]]

vsim $fbasename

add log -r /*
add wave -group dut1 /top_tb/dut1/*
add wave -group dut1 /top_tb/dut1/mem

add wave -group dut2 /top_tb/dut2/*
add wave -group dut2 /top_tb/dut2/mem_data

#add wave "sim:/top_tb/dut2/mem_test"
#add wave "sim:/top_tb/dut1/mem"

#add wave -r *
view -undock wave
run -all