import Structures::*;
//------------------------------------------------------------------------------

module UART_Packets(
  input              ipClk,
  input              ipReset,

  input  UART_PACKET ipTxStream,
  output reg         opTxReady,
  output             opTx,

  input              ipRx,
  output UART_PACKET opRxStream
);
//------------------------------------------------------------------------------

reg[7:0] UART_TxData;
reg UART_TxSend;
reg UART_TxBusy;

reg[7:0] UART_RxData;  
reg UART_RxValid; 

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
WaitForSync,
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
// Transition Logic Broken
always @(posedge(ipClk)) begin
    if (!ipReset) begin
        case(txState) 
            Wait: begin
                if (!ipTxStream.Valid) begin
                    opTxReady <= 1;
                    UART_TxSend <= 0;
                end else begin
                    if (!UART_TxBusy && !UART_TxSend) begin
                        opTxReady <= 0; 
                        UART_TxSend <= 1;
                    end else if (UART_TxBusy) begin   
                        UART_TxSend <= 0;
                        txState <= TransmitSync;
                    end      
                end
            end
            TransmitSync: begin
                if (!UART_TxBusy && !UART_TxSend) begin
                    UART_TxData <= 8'h55;
                    UART_TxSend <= 1;
                end else if (UART_TxBusy)
                    UART_TxSend <= 0;                   
                    txState <= TransmitDestination;
            end
            TransmitDestination: begin
                if (!UART_TxBusy && !UART_TxSend) begin
                    UART_TxData <= ipTxStream.Destination;
                    UART_TxSend <= 1;
                end else if (UART_TxBusy)
                    UART_TxSend <= 0;
                    txState <= TransmitSource;
            end
            TransmitSource: begin
                if (!UART_TxBusy && !UART_TxSend) begin
                    UART_TxData <= ipTxStream.Source;
                    UART_TxSend <= 1;
                end else if (UART_TxBusy)
                    UART_TxSend <= 0;
                    txState <= TransmitLength;
            end
            TransmitLength: begin
                if (!UART_TxBusy && !UART_TxSend) begin
                    UART_TxData <= ipTxStream.Length;
                    UART_TxSend <= 1;
                end else if (UART_TxBusy)
                    UART_TxSend <= 0;
                    txState <= TransmitPayload;
            end
            TransmitPayload: begin
                if (UART_TxBusy) begin
                    UART_TxData <= ipTxStream.Data;
                    UART_TxSend <= 1;
                    txState <= TransmitPayload;
                    if (ipTxStream.EoP)
                        UART_TxSend <= 0;
                        txState <= TransmitDestination;
                end
            end
            default:;   
        endcase

        case(rxState) 
            WaitForSync: begin
                opRxStream.Valid <= 0;
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
                        rxState <= WaitForSync;
                    end
                    BytesReceived <= BytesReceived + 1;
                end 
            end
            default:;   
        endcase
    end else begin
        //Add Reset Code
        rxState <= WaitForSync;
        txState <= Wait;
        BytesReceived <= 0;
        UART_TxSend <= 0;
    end 
end
//------------------------------------------------------------------------------

// TODO: Implement the Rx stream

//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------