import Structures::*;

module Streamer(
    input              			ipClk,
    input              			ipReset,

    input   UART_PACKET     	ipRxStream,
    output  reg     [8:0]  	FIFO_Size, 

    output  reg    [16:0]      Stream,    
    output  reg         			Valid        

);

reg WE;
reg RE;

wire Empty;
wire Full;

reg [15:0] ipData;
reg [15:0] opData;

FIFO FIFOBLOCK(
    .Clock(ipClk),
    .Reset(ipReset),

    .WrEn(WE),
    .RdEn(RE),

    .Data(ipData),
    .Q(opData), 

    .Empty(Empty),
    .Full(Full),

    .WCNT(FIFO_Size)
); 



typedef enum{ 
ReceiveWait,
ReceiveData
} RState;

RState rState;
reg wUpper;
reg rUpper;

always @(posedge(ipClk)) begin
    if (!ipReset) begin
        RE <= !Empty;

        if (rUpper && !Empty) begin
            Stream <= opData[15:8];
            rUpper <= 0;
            Valid  <= 1;
        end else if (!rUpper && !Empty) begin
            Stream <= opData[7:0];
            rUpper <= 1;
            Valid <= 0;
        end

    end else begin
        RE <= 0;
        Valid <= 1;
        rUpper <= 0;
    end
end

always @(posedge(ipClk)) begin
    if (!ipReset) begin
        case (rState)
            ReceiveWait: begin
                if (ipRxStream.Valid && ipRxStream.SoP)
                if (ipRxStream.Destination == 8'h10) begin
                    ipData[7:0] <= ipRxStream.Data;
                    wUpper <= 1;
                    rState <= ReceiveData;
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


endmodule