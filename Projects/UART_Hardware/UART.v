/*------------------------------------------------------------------------------

Implements a 115 200 Bd UART.  ipClk is assumed to be 50 MHz

To send data:

- Set up ipTxData
- Wait for opTxBusy to be low
- Make ipTxSend high
- Wait for opTxBusy to go high
- Make ipTxSend low

To receive data:

- Wait for opRxValid to be high
- opRxData is valid during the same clock cycle
------------------------------------------------------------------------------*/

module UART(
  input           ipClk,
  input           ipReset,

  input      [7:0]ipTxData,
  input           ipTxSend,
  output reg      opTxBusy,
  output reg      opTx,

  input           ipRx,
  output reg [7:0]opRxData,
  output reg      opRxValid
);
//------------------------------------------------------------------------------

reg[9:0] ClkCount = 0; 
reg[3:0] BitsSent = 0; 
reg[3:0] BitRecevied = 0; 

wire ClkBaud = (ClkCount == 434); //Divide the Clock 9 Times

// TODO: Put the transmitter here
always @(posedge(ipClk)) begin
	if(ClkBaud) begin
		ClkCount <= 9'd1;
	end
	else begin 
		ClkCount <= ClkCount + 1'b1;
	end
	
	if (!ipReset) begin
		if (ClkBaud) begin //Main Code Here
			if (ipTxSend || (BitsSent != 1'd0))  begin 
				BitsSent <= BitsSent + 1'b1; 
				 
				if (BitsSent == 0) opTx <= 0; //Start Bit 
				else if (BitsSent == 9) opTx <= 1; //Stop Bit 
				else opTx <= ipTxData[BitsSent-1]; 
				 
				if (BitsSent == 10) begin 
					opTxBusy <= 1'b0; 
					BitsSent <= 16'b0; 
					opTx <= 1; //Idle High 
				end else begin 
					opTxBusy <= 1'b1; 
				end 
			endz
		end
	end else begin //Reset Code Here
		opTxBusy <= 0; 
		opRxValid <= 0; 
		opTx <= 1;
	end
end
//------------------------------------------------------------------------------

// TODO: Put the receiver here

//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------