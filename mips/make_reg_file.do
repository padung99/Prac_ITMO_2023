vlib work

vlog -sv reg_file.sv
vlog -sv reg_file_tb.sv

vsim reg_file_tb

add log -r /*
add wave -r *
run -all

