`timescale 1ns/1ns // unit/precision

module Counter_TB;
	
reg ipClk = 0;
always #10 ipClk <= ~ipClk;
	
	
reg ipReset = 1;
initial begin
	@(posedge ipClk);
	@(posedge ipClk);
	@(posedge ipClk);
	ipReset <= 0;
end

wire [7:0] opLED;

Counter DUT(
	.ipClk(ipClk),
	.opLED(opLED)
);

endmodule
