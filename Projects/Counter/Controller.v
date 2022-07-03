import Structures::*;
//------------------------------------------------------------------------------
module Control(
    input               ipClk,
    input               ipReset,

    output  UART_PACKET opTxStream,
    input				ipTxReady,

	output  reg [7:0]   opAddress,
    output  reg [31:0]  opWrData,
	output  reg         opWrEnable,
	
	input   UART_PACKET ipRxStream,

    input   [31:0]   	ipRdData
);

enum {
	Wait,
	tRead,
	Write
} State;

enum {
	TransmitAddress,
	TransmitPayload
} tState;

reg [1:0] BytesWritten;
reg [1:0] BytesRead;

always @ (posedge(ipClk)) begin
	if (!ipReset) begin
		case (State)
			Wait: begin
				opWrEnable <= 0;
				
				opTxStream.SoP   <= 0;
				opTxStream.EoP   <= 0;
				opTxStream.Valid <= 0;

				if(ipRxStream.Valid && ipRxStream.SoP) begin
					opAddress <= ipRxStream.Data;

					if (ipRxStream.Destination == 0) begin
						State <= tRead;
					end   
					if (ipRxStream.Destination == 1) begin		
						State <= Write;
					end
				end
			end
			Write: begin
				if (ipRxStream.Valid) begin
					opWrData <= {ipRxStream.Data, opWrData[31:8]};
					BytesWritten <= BytesWritten + 1;

					if (BytesWritten == 3) begin
						State <= Wait;
						opWrEnable <= 1;
					end

				end
			end 
			tRead: begin
				case (tState)
					TransmitAddress: begin
						opTxStream.Source      <= ipRxStream.Destination;
						opTxStream.Destination <= ipRxStream.Source;
						opTxStream.Length      <= 8'h05;
						opWrData <= ipRdData;

						if(ipTxReady) begin
							opTxStream.Valid <= 1;
							tState <= TransmitPayload;
						end
					end
					TransmitPayload: begin
						if(ipTxReady) begin
							opTxStream.Data  <= opWrData[7:0];
							opWrData <= {8'hX, opWrData[31:8]};

							BytesWritten <= BytesWritten + 1;

							if(BytesWritten == 3) begin
								opTxStream.Valid <= 0;
								tState <= TransmitAddress;
								State <= Wait;
							end	
						end
					end
				endcase 
			end
		 	default:;	
		endcase
	end else begin // reset code here
		BytesWritten <= 0;
	end
end

endmodule
//------------------------------------------------------------------------------
