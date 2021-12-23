vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/dist_mem_gen_v8_0_13
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap dist_mem_gen_v8_0_13 activehdl/dist_mem_gen_v8_0_13
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 \
"E:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"E:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work dist_mem_gen_v8_0_13  -v2k5 \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Risc5CPU.gen/sources_1/ip/DataRAM/sim/DataRAM.v" \


vlog -work xil_defaultlib \
"glbl.v"

