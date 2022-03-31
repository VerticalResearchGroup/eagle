
comp: top_quark.sv
	vlog -sv -svinputport=net -work work +incdir+../com/intf/ top_quark.sv

sim: 
	#quit -sim
	#vdel -all -lib work
	#vlib work
	#vmap work work
	vsim -c work.top_quark 
	run 10ns

all:
	vlog -sv -svinputport=net -work work +incdir+../com/intf/ top_quark.sv
	vsim work.top_quark 
	run 10ns
	
