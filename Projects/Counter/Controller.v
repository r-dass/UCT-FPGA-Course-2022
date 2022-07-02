import Structures::*;
//------------------------------------------------------------------------------
module Control(
    input               ipClk,
    input               ipReset,

    output  UART_PACKET opTxStream,
    input				ipTxReady,

	output  [7:0]       opAddress,
    output  [31:0]      opWrData,
    output              opWrEnable
	
	input   UART_PACKET ipRxStream,

    input   reg[31:0]   ipRdData,
);

enum {
	Wait,
	Read,
	Write
} State;

enum {
	WriteAddress,
	WriteData
} wState;

reg [1:0] Count;

always @ (posedge(ipClk)) begin
	if (!ipReset) begin
		case (State)
			Wait: begin
				opWrEnable <= 1;

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
				case (wState)
					WriteAddress: begin
						if (ipRxStream.Valid) begin
							opAddress <= ipRxStream.Data;
							WState <= WriteData;
						end		
					end
					WriteData: begin
						if (ipRxStream.Valid) begin
							opWrData <= {ipRxStream.Data, opWrData[31:8]};
							Count <= Count + 1;

							if (Count == 3) begin
								WState <= WriteAddress;
								State <= Wait;
								opWrEnable <= 1;
							end
						end
					end
			end 
			Read: begin

			end
		 	default:;	
		endcase
	end else begin // reset code here
		Count <= 0;
	end
end

endmodule
//------------------------------------------------------------------------------
