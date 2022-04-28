module Counter(
	input			ipClk,
//	input			ipreset,
	output	[7:0]	opLED
);

reg [30:0]Count = 0;

always @(posedge ipClk) begin
//	if (ipReset) Count <= 0;
//	else 
		Count++;
end
	
assign opLED = Count[30:23];

endmodule 