vlib work

vlog -sv alu.sv
vlog -sv ALUControl.sv
vlog -sv alu_alucontrol_tb.sv

vsim alu_alucontrol_tb

add log -r /*
add wave -r *
run -all

