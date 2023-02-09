vlib work

vlog -sv instr_reg.sv
vlog -sv instr_reg_tb.sv

vsim instr_reg_tb

add log -r /*
add wave -r *
run -all

