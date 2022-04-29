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

typedef enum{ // SystemVerilog only
Wait,
Start,
Send,
Stop
} tState;
tState txStates;


reg[9:0] ClkCount = 0; 
reg[3:0] BitsSent = 0; 
reg[3:0] BitsReceived = 0; 
wire ClkBaud = (ClkCount == 433); //Divide the Clock to 115200

reg Rx;

// TODO: Put the transmitter here
always @(posedge(ipClk)) begin
	Rx <= ipRx;
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
				else opTx <= ipTxData >> (BitsSent-1); 
				 
				if (BitsSent == 12) begin 

				end else begin 
					opTxBusy <= 1'b1; 
				end 
			end
			
			if (BitsReceived == 0)begin
				if (Rx == 0) begin 
					opRxValid <= 0;
					BitsReceived <= BitsReceived + 1;
				end else begin
					opRxValid <= 1;
				end
			end else if (BitsReceived == 9) begin
				opRxValid <= 1;
				BitsReceived <= 0;
			end else begin
				opRxData <= {Rx, opRxData[7:1]};
				BitsReceived <= BitsReceived + 1;
			end
		end
	end else begin //Reset Code Here
		opTxBusy <= 0; 
		opRxValid <= 1; 
		opTx <= 1;
	end
end
//------------------------------------------------------------------------------

// TODO: Put the receiver here

//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------