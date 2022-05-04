import Structures::*;
//------------------------------------------------------------------------------
module Control(
    input           ipClk,
    input           ipReset,

    input           ipRxStream,
    output          opTxStream,

    input reg[31:0] ipRdData
    output [7:0]    ipAddress,
    output[31:0]    ipWrData,
    output          ipWrEnable, 
);

endmodule
//------------------------------------------------------------------------------
