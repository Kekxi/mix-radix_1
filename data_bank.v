module data_bank 
    (
    input clk,rst,
    input [4:0] A1,
    input [4:0] A2,
    input [11:0] D,
    input SWEN,
    input SREN,
    input SEN,
    input IWEN,
    input IREN,
    input IEN,
    output reg [11:0] Q
    );
    (*ram_style = "block"*)reg [11:0] bank [31:0];

    // wire [4:0] A1_dy;
    // shift_6 #(.data_width(5)) shf1 (.clk(clk),.rst(rst),.din(A1),.dout(A1_dy));   
    // shift_6 #(.data_width(5)) shf2 (.clk(clk),.rst(rst),.din(A1),.dout(A1_dy)); 
    // shift_6 #(.data_width(5)) shf3 (.clk(clk),.rst(rst),.din(A1),.dout(A1_dy)); 
    // shift_6 #(.data_width(5)) shf4 (.clk(clk),.rst(rst),.din(A1),.dout(A1_dy));  

    always@(posedge clk)
    begin
      if (SEN == 1)
        begin
          if(SWEN == 1'b1)
             bank[A1] <= D;
          else
             bank[A1] <= bank [A1];
          end
    end

    always@(posedge clk)
    begin
      if(SEN == 1)
        begin
          if(SREN == 1'b1)
            Q <= bank[A2];
          else
            Q <= Q;
        end
    end

    always@(posedge clk)
    begin
      if (IEN == 1)
        begin         
          if(IWEN == 1'b1)
             bank[A1] <= D;
          else
             bank[A1] <= bank [A1];
          end
    end
    
    always@(posedge clk)
    begin
      if(IEN == 1)
        begin
          if(IREN == 1'b1)
            Q <= bank[A2];
          else
            Q <= Q;
        end
    end
endmodule