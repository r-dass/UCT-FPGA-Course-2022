import Structures::*;

module Counter(
	input			ipClk,
	input			ipReset,
	input			ipUART_Rx,
	input	[3:0]	ipBtn,
	output			opUART_Tx,
	output	[7:0]	opLED
);

UART_PACKET RxStream;
UART_PACKET TxStream; 
 
RD_REGISTERS RdRegisters;
WR_REGISTERS WrRegisters; 
 
wire TxReady;

wire [7:0] 	Address;
wire [31:0] 	WrData;
wire 			WrEnable;
wire [31:0]	RdData;

wire [15:0]	Stream;
wire Valid;

UART_Packets Packetiser(
  .ipClk	( ipClk		),
  .ipReset	(!ipReset	),

  .ipTxStream(TxStream),
  .opTxReady(TxReady),
  .opTx(opUART_Tx),

  .ipRx(ipUART_Rx),
  .opRxStream(RxStream)
);

Controller Control(
  .ipClk	( ipClk		),
  .ipReset	(!ipReset	),

    .opTxStream(TxStream),
    .ipTxReady(TxReady),

	.opAddress(Address),
    .opWrData(WrData),
	.opWrEnable(WrEnable),
	
	.ipRxStream(RxStream),

    .ipRdData(RdData) 
);

Registers Register(
  .ipClk	( ipClk		),
  .ipReset	(!ipReset	),

  .ipRdRegisters (RdRegisters),
  .opWrRegisters (WrRegisters),

  .ipAddress(Address),
  .ipWrData(WrData),
  .ipWrEnable(WrEnable),
  .opRdData(RdData)
);

Streamer Streamer1(
    .ipClk	( ipClk		),
    .ipReset	(!ipReset	),

  	.ipRxStream(RxStream),
    .opFIFO_Size(RdRegisters.FIFO_Size), 

    .opStream(Stream),     
    .opValid(Valid)
);
 

always @(posedge ipClk) begin
	if (ipReset) begin //reset inverted - normal functionality here
		RdRegisters.ClockTicks <= RdRegisters.ClockTicks + 1;
	end else begin //reset inverted - reset code here
		RdRegisters.ClockTicks <= 0;
	end
end

assign opLED = ~RdRegisters.FIFO_Size;
assign RdRegisters.Buttons = ~ipBtn;


endmodule 