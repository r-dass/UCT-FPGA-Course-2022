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

reg[7:0] Data;
reg[3:0] ClkCount;
wire ClkBaud = (ClkCount == 9); //Divide the Clock 9 Times

// TODO: Put the transmitter here
always @(posedge(ipClk)) begin
	if(ClkBaud) begin
		ClkCount <= 4'd1;
	end
	else begin 
		ClkCount <= ClkCount + 1'b1;
	end
	
	if (!ipReset) begin
		if (ClkBaud) begin //Main Code Here

		end
	end else begin //Reset Code Here
		
	end
end
//------------------------------------------------------------------------------

// TODO: Put the receiver here

//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------