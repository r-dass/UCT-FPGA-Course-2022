module Counter(
	input			ipClk,
	input			ipReset,
	input			ipUART_Rx,
	output			opUART_Tx,
	output	[7:0]	opLED
);

reg [30:0]Count = 0;

reg  [7:0]UART_TxData;
reg       UART_TxSend;
wire      UART_TxBusy;

wire [7:0]UART_RxData;
wire      UART_RxValid;

UART UART_Inst(
  .ipClk    ( ipClk   ),
  .ipReset  (ipReset),

  .ipTxData (  UART_TxData),
  .ipTxSend (  UART_TxSend),
  .opTxBusy (  UART_TxBusy),
  .opTx     (opUART_Tx    ),

  .ipRx     (ipUART_Rx     ),
  .opRxData (  UART_RxData ),
  .opRxValid(  UART_RxValid)
);

always @(posedge ipClk) begin
	if (!ipReset) Count <= 0;
	else 
		Count++;
		
  if(~UART_TxSend && ~UART_TxBusy) begin
    case(UART_RxData) inside
      8'h0D    : UART_TxData <= 8'h0A; // Change enter to linefeed
      "0"      : UART_TxData <= 8'h0D; // Change 0 to carriage return
      ["A":"Z"]: UART_TxData <= UART_RxData ^ 8'h20;
      ["a":"z"]: UART_TxData <= UART_RxData ^ 8'h20;
      default  : UART_TxData <= UART_RxData;
    endcase
    UART_TxSend <= UART_RxValid;

  end else if(UART_TxSend && UART_TxBusy) begin
    UART_TxSend <= 0;
  end
end

assign opLED = Count[30:23];


endmodule 