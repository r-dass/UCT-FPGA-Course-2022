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

typedef enum{ 
Wait,
TransmitSync,
TransmitDestination,
TransmitSource,
TransmitLength,
TransmitPayload
} tState;
tState txState;

reg[2:0] BytesReceived;

//------------------------------------------------------------------------------

// TODO: Implement the Tx stream

always @(posedge(ipClk)) begin
    if (!ipReset) begin
        case(txState) 
            Wait: begin
                txState <= TransmitSync;
            end
            TransmitSync: begin
                txState <= TransmitDestination;
            end
            TransmitDestination: begin
                txState <= TransmitSource;
            end
            TransmitSource: begin
                txState <= TransmitLength;
            end
            TransmitLength: begin
                txState <= TransmitPayload;
            end
            TransmitPayload: begin
                txState <= Wait;
            end
            default:;   
        endcase

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
                    opRxStream.Data <= UART_RxData;
                    if (BytesReceived == 0) begin
                        opRxStream.SoP <=1;
                    end 
                    if (BytesReceived == 1) begin
                        opRxStream.SoP <= 0;
                    end 
                    if (BytesReceived == opRxStream.Length - 1) begin
                        opRxStream.EoP <=1;
                    end
                    if (BytesReceived == opRxStream.Length) begin
                        opRxStream.EoP <= 0;
                        opRxStream.Valid <=1;
                        rxState <= ReceiveSync;
                    end
                    BytesReceived <= BytesReceived + 1;
                end else begin
                    opRxStream.Valid <= 0;
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