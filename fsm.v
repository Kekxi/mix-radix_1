module fsm (
  input clk,rst,
  input wire [2:0] conf,
//   output wire sel,
  output wire [4:0] i,
  output wire [4:0] k, //max = 31
  output wire [4:0] j, //max = 31
  output wire [3:0] p, //max = 2
  output wire swen,
  output wire sren,
  output wire sen,
  output wire iwen,
  output wire iren,
  output wire ien,
  output wire [1:0] done_flag);
  
  parameter IDLE = 3'b000;
  parameter RADIX2 = 3'b001;
  parameter RADIX4 = 3'b010;
//   parameter PWM = 3'b010;
//   parameter INTT = 3'b011;
  parameter DONE_RADIX2 = 3'b011;
  parameter DONE_RADIX4 = 3'b100;
  // parameter DONE_INTT = 3'b101;

  reg swen_reg,sren_reg,sen_reg;
  wire sen_reg_q,sen_reg_q_tmp;
  reg iwen_reg,iren_reg,ien_reg;
  wire ien_reg_q,ien_reg_q_tmp;
  reg [2:0] conf_state;
  reg [4:0] i_reg;
  reg [7:0] k_reg,j_reg;
  reg [3:0] p_reg;
  reg [3:0] done_reg;
  wire [2:0] end_stage,begin_stage;
  wire [3:0] p_shift;
  
  assign i = i_reg;
  assign j = j_reg;
  assign k = k_reg;
  assign p = p_reg;
  assign done_flag = done_reg;

  // radix2 阶段 输出读写   
  assign sen = ((conf == DONE_RADIX4) || (conf == DONE_RADIX2)) ? sen_reg_q : sen_reg_q_tmp;
  shift_14 #(.data_width(1)) shif_swen(.clk(clk),.rst(rst),.din(swen_reg),.dout(swen));
  shift_13 #(.data_width(1)) shif_sen(.clk(clk),.rst(rst),.din(sen_reg_q_tmp),.dout(sen_reg_q));
  
  DFF #(.data_width(1)) dff_sen(.clk(clk),.rst(rst),.d(sen_reg),.q(sen_reg_q_tmp));
  DFF #(.data_width(1)) dff_sren(.clk(clk),.rst(rst),.d(sren_reg),.q(sren));

  // radix4 阶段 地址读写使能信号
  assign ien = ((conf == DONE_RADIX4) || (conf == DONE_RADIX2)) ? ien_reg_q : ien_reg_q_tmp;
  shift_14 #(.data_width(1)) shif_iwen(.clk(clk),.rst(rst),.din(iwen_reg),.dout(iwen));
  shift_13 #(.data_width(1)) shif_ien(.clk(clk),.rst(rst),.din(ien_reg_q_tmp),.dout(ien_reg_q));
  
  DFF #(.data_width(1)) dff_ien(.clk(clk),.rst(rst),.d(ien_reg),.q(ien_reg_q_tmp));
  DFF #(.data_width(1)) dff_iren(.clk(clk),.rst(rst),.d(iren_reg),.q(iren));
  
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      conf_state <= IDLE;
    else
      conf_state <= conf;
  end
  
  always@(*)
  begin
    // sel_reg = 0;
    sen_reg = 0; 
    swen_reg = 0;
    sren_reg = 0; 
    ien_reg = 0; 
    iwen_reg = 0;
    iren_reg = 0; 
    done_reg = 4'b0;
    case(conf_state)
    IDLE:begin 
        //      sel_reg = 0;
        sen_reg = 0; 
        swen_reg = 0;
        sren_reg = 0; 
        ien_reg = 0; 
        iwen_reg = 0;
        iren_reg = 0; 
        done_reg = 4'b0;
        end

    RADIX2:begin
        sen_reg = 1; 
        swen_reg = 1;
        sren_reg = 1;
         if(i_reg == 5'd31)
           done_reg = 2'b01;
         else
           done_reg = 2'b0;
        end

    RADIX4:begin 
        //  sel_reg = 0;
         ien_reg = 1; 
         iwen_reg = 1;
         iren_reg = 1;
         if((p_reg == 0)&&(k_reg == 31)&&(j_reg == 0))begin
           done_reg = 2'b10; end
         else begin
           done_reg = 4'b0; end
         end

    DONE_RADIX2:begin 
        //  sel_reg = 0;
         sen_reg = 0;
         swen_reg = 0;
         sren_reg = 0; 
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
         p_reg <= 3'd0;
        end

    DONE_RADIX4:begin 
        //  sel_reg = 0;
         sen_reg = 0;
         swen_reg = 0;
         sren_reg = 0; 
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
        p_reg <= 3'd0;
        end

    default:begin 
        //  sel_reg = 0;
         done_reg = 4'b1;
         sen_reg = 0;
         swen_reg = 0;
         sren_reg = 0; 
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
         end
     endcase
  end
 
 assign end_stage = conf == RADIX4 ? 0 : 2;
 assign begin_stage = conf == RADIX4 ? 2 : 3;
 assign p_shift = p_reg << 1;
 
  always@(posedge clk or posedge rst)
  begin 
     if(rst)
     begin
         p_reg <= begin_stage;
         j_reg <= 0;
         k_reg <= 0;
         i_reg <= 0;
     end
     else if((conf_state == RADIX2))
     begin
        //  p_reg <= 3'd3;
         i_reg <= i_reg + 1;
     end

     else if((conf_state == RADIX4))
     begin
        if(j_reg == (1 << (p_shift)) - 1)
        begin
           j_reg <= 0;
           if(k_reg == (32 >> p_shift) - 1)
           begin
              k_reg <= 0;
              if(p_reg == end_stage)
                 p_reg <= begin_stage;
              else
                   p_reg <= p_reg - 1;
           end
           else
              k_reg <= k_reg + 1;
         end
         else
            j_reg <= j_reg + 1;
     end
     else
     begin
       p_reg <= begin_stage;
       j_reg <= 0;
       k_reg <= 0;
       i_reg <= 0;
     end
   end
endmodule