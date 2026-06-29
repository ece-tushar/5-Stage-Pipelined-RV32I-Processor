module pipe_IF_ID #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
    )( input logic Clk,Rst,Flush,
       input logic [ADDR_WIDTH-1:0] PC_in,
       input logic [DATA_WIDTH-1:0] IM_in,
       output logic [ADDR_WIDTH-1:0] PC_out,
       output logic [DATA_WIDTH-1:0] IM_out
       );
       
   struct packed {
        logic [ADDR_WIDTH-1:0] PC;
        logic [DATA_WIDTH-1:0] IM;
        } IF_ID;
   
   always_ff @ (posedge Clk) begin
        if (Rst || Flush) begin
            IF_ID <= '0;
            end
        else begin
            IF_ID.PC <= PC_in;
            IF_ID.IM <= IM_in;
            end
   end

assign PC_out = IF_ID.PC; 
assign IM_out = IF_ID.IM; 
            
      
endmodule