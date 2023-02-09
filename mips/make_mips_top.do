vlib work

vlog -sv controlUnit.sv
vlog -sv  instr_reg.sv
vlog -sv  instr_memory.sv
vlog -sv  reg_file.sv
vlog -sv  alu.sv
vlog -sv  ALUControl.sv
vlog -sv  ProgramCounter.sv
vlog -sv  mult_2to1.sv
vlog -sv  mult_3to1.sv
vlog -sv  mult_4to1.sv
vlog -sv  sign_extend.sv
vlog -sv  multiplyBy4.sv
vlog -sv mips_top.sv
vlog -sv mips_top_tb.sv

vsim mips_top_tb

add log -r /*
add wave -r *
run -all

