import Structures::*;
//------------------------------------------------------------------------------

module UART_Packets(
  input              ipClk,
  input              ipReset,

  input  UART_PACKET ipTxStream,
  output             opTxReady,
  output             opTx,

  input              ipRx,
  output UART_PACKET opRxStream
);
//------------------------------------------------------------------------------

reg[7:0] UART_TxData;
reg[7:0] UART_RxData;

reg UART_TxSend;
reg UART_TxBusy;
reg UART_RxValid; 

reg TxReady;

// TODO: Instantiate the UART module here
UART UART_Inst(
  .ipClk    ( ipClk   ),
  .ipReset  (ipReset),

  .ipTxData (  UART_TxData),
  .ipTxSend (  UART_TxSend),
  .opTxBusy (  UART_TxBusy),
  .opTx     (opTx    ),

  .ipRx     (ipRx     ),
  .opRxData (  UART_RxData ),
  .opRxValid(  UART_RxValid)
);

typedef enum{ 
ReceiveSync,
ReceiveDestination,
ReceiveSource,
ReceiveLength,
ReceivePayload
} rState;
rState rxState;

reg[2:0] BytesReceived;

//------------------------------------------------------------------------------

// TODO: Implement the Tx stream

always @(posedge(ipClk)) begin
    if (!ipReset) begin
        case(rxState) 
            ReceiveSync: begin
                if (UART_RxValid && (UART_RxData == 'h55)) begin
                    rxState <= ReceiveDestination;
                end
            end
            ReceiveDestination: begin
                if (UART_RxValid) begin
                    opRxStream.Destination <= UART_RxData;
                    rxState <= ReceiveSource;
                end
            end
            ReceiveSource: begin
                if (UART_RxValid) begin
                    opRxStream.Source <= UART_RxData;
                    rxState <= ReceiveDestination;
                end
            end
            ReceiveLength: begin
                if (UART_RxValid) begin
                    opRxStream.Length <= UART_RxData;
                    rxState <= ReceivePayload;
                end
            end
            ReceivePayload: begin
                if (UART_RxValid) begin
                    opRxStream.Data <= opRxStream.Data >> 8;
                    opRxStream.Length <= UART_RxData;
                end else if (BytesReceived == opRxStream.Length) begin
                    rxState <= ReceivePayload;
                end
            end
            default:;   
        endcase
    end else begin
        //Add Reset Code
        rxState <= ReceiveSync;
        BytesReceived <= 0;
    end 
end
//------------------------------------------------------------------------------

// TODO: Implement the Rx stream

//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------