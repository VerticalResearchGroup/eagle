
comp: l2cache_store.sv 
	vlog -work work +incdir+../com/intf/+../defs/ *.v
sim: 
	vsim -c work.top_mem_sys 
	run 10ns

all:
	vlog -sv -svinputport=net -work work +incdir+../com/intf/ top_mem_sys.sv
	vsim work.top_mem_sys 
	run 10ns
	
