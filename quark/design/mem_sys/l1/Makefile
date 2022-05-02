
comp: icache_store.v 
	vlog -work work +incdir+../com/intf/+../defs/ *.v
sim: 
	#quit -sim
	#vdel -all -lib work
	#vlib work
	#vmap work work
	vsim -c work.top_mem_sys 
	run 10ns

all:
	vlog -sv -svinputport=net -work work +incdir+../com/intf/ top_mem_sys.sv
	vsim work.top_mem_sys 
	run 10ns
	
