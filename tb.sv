module tb;

logic clock;

memory m(clock);

always #5 clock = !clock;

initial 
begin
	clock=0;
	#4100;
	$finish;
end

endmodule
	