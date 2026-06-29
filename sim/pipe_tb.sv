module pipe_tb;

parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 32;

logic  Rst,Clk;
logic [ADDR_WIDTH-1:0] PC_in;
logic [DATA_WIDTH-1:0] IM_in;
logic [ADDR_WIDTH-1:0] PC_out;
logic [DATA_WIDTH-1:0] IM_out;

logic [ADDR_WIDTH-1:0] arrpc [0:9];
logic [ADDR_WIDTH-1:0] arrim [0:9];
logic [DATA_WIDTH-1:0] checkpc [0:9];
logic [DATA_WIDTH-1:0] checkim [0:9];

initial begin
Rst = 0;
Clk = 1;
arrpc = '{1,2,3,4,5,6,7,8,9,10};
arrim = '{11,12,13,14,15,16,17,18,19,20};
checkpc = '{default:0};
checkim = '{default:0};
end

pipe_IF_ID uut (.Rst(Rst),.Clk(Clk),
                .PC_in(PC_in),.IM_in(IM_in),
                .PC_out(PC_out),.IM_out(IM_out));
                
task reset;
begin
    @(negedge Clk)
        Rst=1;
    
    repeat (2) @(negedge Clk);
    
    @(negedge Clk) 
        Rst = 0;
end
endtask

task write_store;
//integer i;
begin
    foreach(arrpc[i]) begin
        @(negedge Clk) begin
            PC_in = arrpc[i];
            IM_in = arrim[i];
            end
        @(negedge Clk) begin
            checkpc[i] = PC_out;
            checkim[i] = IM_out;
            end
     end
end
endtask

task check;
    integer pc, im;

    begin
        pc = 0;
        im = 0;

        foreach (arrpc[i]) begin

            if (arrpc[i] == checkpc[i]) begin
                $display("PASS : PC[%0d] Expected = %0h, Got = %0h",
                         i, arrpc[i], checkpc[i]);
                pc++;
            end
            else begin
                $display("FAIL : PC[%0d] Expected = %0h, Got = %0h",
                         i, arrpc[i], checkpc[i]);
            end

            if (arrim[i] == checkim[i]) begin
                $display("PASS : IM[%0d] Expected = %0h, Got = %0h",
                         i, arrim[i], checkim[i]);
                im++;
            end
            else begin
                $display("FAIL : IM[%0d] Expected = %0h, Got = %0h",
                         i, arrim[i], checkim[i]);
            end

        end

        $display("----------------------------------------");
        $display("PC  : %0d/%0d Passed", pc, $size(arrpc));
        $display("IM  : %0d/%0d Passed", im, $size(arrim));

        if ((pc == $size(arrpc)) && (im == $size(arrim)))
            $display("******** TEST PASSED ********");
        else
            $display("******** TEST FAILED ********");

    end
endtask

always #5 Clk = ~Clk;

initial begin
    reset();
    write_store();
    check();
end


endmodule
