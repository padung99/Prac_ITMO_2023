vlib work

vlog -sv controlUnit.sv
vlog -sv controlUnit_tb.sv

vsim controlUnit_tb

add log -r /*
add wave -r *
run -all

