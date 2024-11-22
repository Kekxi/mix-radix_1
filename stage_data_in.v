module stage_data_in(
    input clk,
    input SEN,
    input SREN,
    input  [6:0] A0,
    input  [6:0] A1,
    input  [6:0] A2,
    input  [6:0] A3,
    output reg [11:0] Q0,
    output reg [11:0] Q1,
    output reg [11:0] Q2,
    output reg [11:0] Q3
);

    (*ram_style = "block"*)reg [11:0] data [127:0]; 
    
    always @(posedge clk)
    begin
        if(SEN == 1)
        begin
             if(SREN == 1'b1)
             begin
                Q0 <= data[A0];
                Q1 <= data[A1];
                Q2 <= data[A2];
                Q3 <= data[A3];
             end
             else 
            begin
                Q0 <= Q0;
                Q1 <= Q1;
                Q2 <= Q2;
                Q3 <= Q3;
             end
        end

    end 

endmodule