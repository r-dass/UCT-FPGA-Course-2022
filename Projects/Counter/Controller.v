import Structures::*;
//------------------------------------------------------------------------------
module Control(
    input               ipClk,
    input               ipReset,

    input   UART_PACKET ipRxStream,
    output  UART_PACKET opTxStream,

    input   reg[31:0]   ipRdData
    output  [7:0]       ipAddress,
    output  [31:0]      ipWrData,
    output              ipWrEnable, 
);

always @ (posedge(ipClk)) begin
  if(ipRxStream.Valid) begin
      if (ipRxStream.ipAddress == 0) begin
          // write
      end  

      if (ipRxStream.ipAddress == 1) begin
          // read
      end
  end
end

endmodule
//------------------------------------------------------------------------------
