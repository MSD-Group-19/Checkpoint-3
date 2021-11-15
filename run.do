vlib work
vdel -all

vlib work
vlog memory.sv
vlog tb.sv

vsim work.tb  +debug=1 +tracefile=trace1.txt 
run -all