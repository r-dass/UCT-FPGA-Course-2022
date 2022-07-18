import Structures::*;

module Streamer(
    input              			ipClk,
    input              			ipReset,

    input   UART_PACKET     	ipRxStream,
    output  reg     [8:0]  	    opFIFO_Size, 

    output  reg    [15:0]       opStream,    
    output  reg         		opValid
);  

reg WE;  
reg RE;
 
wire Empty;
wire Full;

wire [8:0] FIFO_Size1;

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

    .WCNT(FIFO_Size1)
);  

typedef enum{ 
ReceiveWait,
ReceiveData
} RState;

RState rState;
reg wUpper;
reg rUpper;

assign opFIFO_Size = FIFO_Size1;
 
always @(posedge(ipClk)) begin
    if (!ipReset) begin
        RE <= !Empty;
        opValid <= !Empty;
    end else begin
        RE <= 0;
        opValid <= 0;
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


endmodule