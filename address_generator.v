`timescale 1ns / 1ps
module address_generator(
    input clk,rst,
    input [4:0] i,//max = 31
    input [4:0] k,//max = 31
    input [4:0] j,//max = 31
    input [2:0] p,//阶段数 
    output wire [6:0] old_address_0,old_address_1,old_address_2,
    output wire [6:0] old_address_3
);

	reg [6:0] old_address_0_reg,old_address_1_reg,old_address_2_reg,old_address_3_reg;

    assign old_address_1 = old_address_1_reg;
    assign old_address_2 = old_address_2_reg;
    assign old_address_3 = old_address_3_reg;
    assign old_address_0 = old_address_0_reg;

    always@(*)
    begin
      case(p)
      2'd11: old_address_0_reg = i;
      2'd10: old_address_0_reg = ((k << 2) << (p << 1)) + j; 
      2'd01: old_address_0_reg = ((k << 2) << (p << 1)) + j; 
      2'd00: old_address_0_reg = ((k << 2) << (p << 1)) + j;  
      default:old_address_0_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      2'd11: old_address_1_reg = {old_address_0_reg[6],1'b1,old_address_0_reg[4:0]};
      2'd10: old_address_1_reg = {old_address_0_reg[6:5],1'b1,old_address_0_reg[3:0]};  
      2'd01: old_address_1_reg = {old_address_0_reg[6:3],1'b1,old_address_0_reg[1:0]};  
      2'd00: old_address_1_reg = {old_address_0_reg[6:1],1'b1};  
      default:old_address_1_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      2'd11: old_address_2_reg = {1'b1,old_address_0_reg[5:0]};    
      2'd10: old_address_2_reg = {old_address_0_reg[6],1'b1,old_address_0_reg[4:0]};  
      2'd01: old_address_2_reg = {old_address_0_reg[6:4],1'b1,old_address_0_reg[2:0]};  
      2'd00: old_address_2_reg = {old_address_0_reg[6:2],1'b1,old_address_0_reg[0]};  
      default:old_address_2_reg = old_address_0_reg;
      endcase
    end
    
    always@(*)
    begin
      case(p)
      2'd11: old_address_3_reg = {1'b1,old_address_1_reg[5:0]};     
      2'd10: old_address_3_reg = {old_address_0_reg[6],2'b11,old_address_0_reg[3:0]};  
      2'd01: old_address_3_reg = {old_address_0_reg[6:4],2'b11,old_address_0_reg[1:0]};
      2'd00: old_address_3_reg = {old_address_0_reg[6:2],2'b11};
      default: old_address_3_reg = old_address_0_reg;
      endcase
    end
     

endmodule