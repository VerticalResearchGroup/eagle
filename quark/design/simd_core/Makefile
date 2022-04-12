comp: riscv_32_test_pkg.sv steel_core_64.v steel_core_tb.sv
	vlog -v -vinputport=net -work work steel_core_64.v
	vlog -sv -svinputport=net -work work +incdir+./riscv-tests/ steel_core_tb.sv
	vlog -sv -svinputport=net -work work simd_core_top.sv
	#riscv_32_test_pkg.sv

sim: 
	#quit -sim
	#vdel -all -lib work
	#vlib work
	#vmap work work
	vsim -c work.steel_core_tb 
	run 10ns

all:
	vlog -sv -svinputport=net -work work +incdir+../com/intf/ top_quark.sv
	vsim work.top_quark 
	run 10ns
	
