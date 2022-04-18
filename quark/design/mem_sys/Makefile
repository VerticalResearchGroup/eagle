
comp: top_mem_sys.sv
	vlog -sv -svinputport=net -work work +incdir+../com/intf/+l1/+l2/+mra/ *.sv 

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
	
