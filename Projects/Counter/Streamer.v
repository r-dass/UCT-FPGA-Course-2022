import Structures::*; 

module Streamer(
    input              			ipClk,
    input              			ipReset,

    input   UART_PACKET     	ipRxStream,
    output  reg     [12:0]  	    opFIFO_Size, 

    output  reg    [15:0]       opStream,     
    output  reg         		opValid,

    output UART_PACKET          opTxStream
);  

reg WE;  
reg RE;
 
wire Empty;
wire Full;

wire [12:0] FIFO_Size1;

reg [15:0] ipData;

reg [12:0] txClkCount;

FIFO FIFOBLOCK(
    .Clock(ipClk),
    .Reset(ipReset),

    .WrEn(WE),
    .RdEn(RE),

    .Data(ipData),
    .Q(opStream), 

    .Empty(Empty),
    .Full(Full),

    .WCNT(FIFO_Size1)
);  

typedef enum{ 
ReceiveWait,
ReceiveData
} RState;

RState rState;

typedef enum{ 
CheckSize,
TransmitPacket,
TransmitComplete
} TState;

TState tState;
reg wUpper;
reg rUpper;

assign opFIFO_Size = FIFO_Size1;
 
always @(posedge(ipClk)) begin
    if (!ipReset) begin
        if (txClkCount == 566 && !Empty) begin
            RE <= 1;
            opValid <= 1;
            txClkCount <= 0;
        end else begin
            txClkCount <= txClkCount + 1;
            RE <= 0;
            opValid <= 0;
        end

    end else begin
        RE <= 0;
        opValid <= 0;
        txClkCount <= 0;
    end
end

always @(posedge(ipClk)) begin
    if (!ipReset) begin
        case (rState)
            ReceiveWait: begin
                WE <= 0;
                if (ipRxStream.Valid && ipRxStream.SoP) begin
                    if (ipRxStream.Destination == 8'h10) begin
                        ipData[7:0] <= ipRxStream.Data;
                        wUpper <= 1;
                        rState <= ReceiveData;
                    end 
                end  
            end
            ReceiveData: begin
                if (ipRxStream.Valid) begin
                    if (wUpper) begin  //lower byte then upper byte
                        ipData[15:8] <= ipRxStream.Data;
                        WE <= 1;
                        wUpper <= 0;
                    end else begin
                        ipData[7:0] <= ipRxStream.Data;
                        WE <= 0;
                        wUpper <= 1;
                    end
                    if (ipRxStream.EoP) begin
                        rState <= ReceiveWait;
                    end
                end else
					WE <= 0;
            end
            default:;
        endcase
    end else begin
        rState <= ReceiveWait;
        wUpper <= 0;
        WE <= 0;
    end
end

always @(posedge(ipClk)) begin
    if(!ipReset) begin
            opTxStream.SoP    <= 1;
            opTxStream.EoP    <= 1;
            opTxStream.Length <= 1;
            opTxStream.Source <= 8'hAA;
            opTxStream.Data <= FIFO_Size1 >> 11;

        case (tState) 
            CheckSize: begin
                if (FIFO_Size1 == 3171 || FIFO_Size1 == 2047 || FIFO_Size1 == 1023 || Empty) begin 
                   tState<= TransmitPacket
                end
            end 
            TransmitPacket: begin
                if (ipTxReady) begin
                    opTxStream.Valid <= 1;
                    tState<= TransmitComplete
                end
            end
            TransmitComplete: begin
                if (ipTxReady) begin
                    opTxStream.Valid <= 0;
                    tState<= CheckSize;
                end
            end
            default:;
        endcase
    end else begin
        opTxStream.SoP    <= 0;
        opTxStream.EoP    <= 0;
        opTxStream.Length <= 0;
        opTxStream.Source <= 0;
        opTxStream.Data <= 0;

        opTxStream.Valid <= 1;
        
    end
end


endmodule