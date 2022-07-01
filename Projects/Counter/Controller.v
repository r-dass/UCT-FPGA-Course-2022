import Structures::*;
//------------------------------------------------------------------------------
module Control(
    input               ipClk,
    input               ipReset,

    input				ipTxReady,
	
	input   UART_PACKET ipRxStream,
    output  UART_PACKET opTxStream,

    input   reg[31:0]   ipRdData,
    output  [7:0]       opAddress,
    output  [31:0]      opWrData,
    output               opWrEnable
);

enum {
	Wait,
	Read,
	Write
} State;

always @ (posedge(ipClk)) begin
	if (!ipReset) begin
		case (State)
			Wait: begin
				if(ipRxStream.Valid && ipRxStream.SoP) begin
					if (ipRxStream.Destination == 0) begin
						State <= Read;
					end   
					if (ipRxStream.Destination == 1) begin
						State <= Write;
					end
				end
			end
			Write: begin

			end 
			Read: begin

			end
		 	default:;	
		endcase
	end else begin // reset code here
		
	end
end

endmodule
//------------------------------------------------------------------------------
